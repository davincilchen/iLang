class LessonsController < ApplicationController
  helper_method :sort_column, :sort_direction
  #index action 用來找出是否有ongoing lesson
  def index
    #找出所有自己上過或者正要上的課
    # @lessons = Lesson.where("teacher_id = ? or student_id = ?",current_user,current_user).search(params[:search]).order(sort_column + " " + sort_direction)
    @lessons = Lesson.where(teacher_id: current_user.id).or(Lesson.where(student_id: current_user.id)).search(params[:search]).order(sort_column + " " + sort_direction)
    #找出是否有正要上的課 status 預設是 false 代表已經完成的的課
    #status 為true 表示正要上的課 同一個時間只能有一堂課在進行
    @lesson = @lessons.find{ |x| x.status == true }
  end

  def new
    logger.debug current_user.is_ongoing_lesson?
    if current_user.is_ongoing_lesson?
      redirect_to ongoing_lessons_path
    else
      @lesson = Lesson.new
    end
  end

  def ongoing
    if current_user.is_ongoing_lesson?
      #找出所有自己上過或者正要上的課
      # @lessons = Lesson.where("teacher_id = ? or student_id = ?",current_user,current_user).search(params[:search]).order(sort_column + " " + sort_direction)
      @lessons = Lesson.where("teacher_id = ? or student_id = ?",current_user,current_user)
      #找出是否有正要上的課 status 預設是 false 代表已經完成的的課
      #status 為true 表示正要上的課 同一個時間只能有一堂課在進行
      @lesson = @lessons.find{ |x| x.status == true }     
    else
      redirect_to lessons_path
    end
  end

  #create action會有role, friend_id, language_id, title四個params傳入
  def create
    #檢查role friend language是否都有被選擇 若有 根據role的角色新增teach或learn課程
    if params[:role].present? && params[:friendship][:id].present? && params[:language][:id].present? 
    #先檢查是否有正在進行的課程 若有 無法新增一堂課程 必須先完成進行中課程
      partner_user = User.find(params[:friendship][:id])
      if current_user.is_ongoing_lesson?
        flash[:alert] = "您有一個正在進行中的課程，請先完成它"
        redirect_to ongoing_lessons_path
      elsif partner_user.is_ongoing_lesson?
        flash[:alert] = "您的朋友有一個正在進行中的課程，請等他完成它"
        redirect_to new_lesson_path   
      else
        if params[:role] == "teacher"
          @lesson = current_user.teached_lessons.build(lesson_params)
          @lesson.student_id = params[:friendship][:id]
        else
          @lesson = current_user.learned_lessons.build(lesson_params)
          @lesson.teacher_id = params[:friendship][:id]     
        end
        #利用generate_random_pad method建立10位元的隨機字串當作etherpad課程id
        @lesson.generate_random_pad
        @lesson.language_id = params[:language][:id]
        if @lesson.save
          redirect_to lesson_path(@lesson)
        else
          #若title為空 顯示錯誤訊息
          logger.debug "New error: #{@lesson.errors.full_messages.to_sentence}"
          flash[:alert] = @lesson.errors.full_messages.to_sentence
          render :action => :new
        end
      end
    else
      #role friend language任一沒有被選擇 提示必須選取所有選項
      flash[:alert] = "請選擇所有選項"
      # 回上頁(如果是從user show 來, 就會回到那一頁)
      redirect_back fallback_location: root_path
    end
  end

  #ajax action 用來動態根據role及friend找出他想學或者想教的語言選項
  def update_languages
    #沒有選擇role 直接選擇friend時 提示選擇角色
    if params[:role].blank?
      @enable_alert = true
      respond_to do |format|
        format.js { flash.now[:alert] = "請選擇你的身份" }
      end
    #選擇role還未選擇friend 因是正常步驟 不做任何事
    elsif params[:friendship_id].blank?
      @enable_alert = false
    else
      if params[:role] == "teacher"
        @user = User.find(params[:friendship_id])
        @languages = @user.learning_languages
      else
        @languages = current_user.learning_languages
      end      
      respond_to do |format|
        format.js
      end
    end
  end

  before_action :get_lesson, only: [:show, :update]

  def show
  end

  def update
    # url = "http://127.0.0.1:9001/api/1/getText?apikey=2113a5136cdc865146faab71c441141110311940d9c50c96080276eb6f781752&padID=#{@lesson.pad_id}"
    url = "http://etherpad-lite-test-font.herokuapp.com/api/1/getText?apikey=60ab94c4ffb59abc33b3b5dcb2e92af48ac0b2544fa3d8ff3d7d172f573ee7c2&padID=#{@lesson.pad_id}"
    response = RestClient.get(url)
    data = JSON.parse(response.body)
    @lesson.status = "false"
    @lesson.content = data["data"]["text"]
    if @lesson.update(lesson_content_param)
      text = data["data"]["text"]
      text.to_s.split("\n").each do |vocal|
        @tmp_vocabs = Vocab.where("key = ? and student_id = ? and lesson_id = ?", vocal.to_s.split(":")[0],@lesson.student_id,@lesson.id)
        isVocab = vocal.to_s.split(":")[1]
        if @tmp_vocabs.first.nil? && isVocab.present?
          @vocab = @lesson.vocabs.build(vocab_params)
          @vocab.lesson_id = @lesson.id
          @vocab.language_id = @lesson.language_id
          @vocab.student_id = @lesson.student_id
          @vocab.key = vocal.to_s.split(":")[0]
          @vocab.value = vocal.to_s.split(":")[1]
          if @vocab.save
            flash[:notice] = "課程結束且生字已被儲存"
          else
            flash[:alert] = @vocab.errors.full_messages.to_sentence
          end
        else
          flash[:notice] = "課程結束"
        end
      end
      redirect_to root_path
    else
      flash[:alert] = @lesson.errors.full_messages.to_sentence
      render :action => :show
    end
  end

  def review
    @lessons = Lesson.where("student_id = ? and status = ?", current_user.id,false).search(params[:search]).order(sort_column + " " + sort_direction)
  end

  private
  def get_lesson
    @lesson = Lesson.find(params[:id])
  end

  def lesson_params
    params.require(:lesson).permit(:title, :teacher_id, :student_id, :language_id)
  end

  def lesson_content_param
    params.permit(:content)
  end

  def vocab_params
    params.permit(:lesson_id, :student_id, :language_id, :key, :value)
  end

  def sort_column
    Lesson.column_names.include?(params[:sort]) ? params[:sort] : "title"

  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
