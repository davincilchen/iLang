class LessonsController < ApplicationController
  helper_method :sort_column, :sort_direction
  #index action 用來找出是否有ongoing lesson
  def index
    #找出所有自己上過或者正要上的課
    # @lessons = Lesson.where("teacher_id = ? or student_id = ?",current_user,current_user).search(params[:search]).order(sort_column + " " + sort_direction)
    @lessons = Lesson.where(teacher_id: current_user.id).or(Lesson.where(student_id: current_user.id)).search(params[:search]).order(sort_column + " " + sort_direction)
    #找出是否有正要上的課 status 預設是 false 代表已經完成的的課
    #status 為true 表示正要上的課 同一個時間只能有一堂課在進行
    @lessons.each do |lesson|
      if lesson.status == true
        @lesson = lesson
      end
    end

  end

  def new
    @lesson = Lesson.new
  end

  #create action會有role, friend_id, language_id, title四個params傳入
  def create
    #先檢查是否有正在進行的課程 若有 無法新增一堂課程 必須先完成進行中課程
    if current_user.is_ongoing_lesson?
      flash[:alert] = "There is an ongoing lesson, please finished it first!!"
      redirect_to lessons_path
    else
      #檢查role friend language是否都有被選擇 若有 根據role的角色新增teach或learn課程
      unless params[:role].blank? || params[:friendship][:id].blank? || params[:language][:id].blank? 
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
      else
        #role friend language任一沒有被選擇 提示必須選取所有選項
        flash[:alert] = "Please select all item"
          if params[:id] == ""
            redirect_to new_lesson_path
          else
            # 回上頁(如果是從user show 來, 就會回到那一頁)
            redirect_back fallback_location: root_path
          end
      end
    end
  end

  #ajax action 用來動態根據role及friend找出他想學或者想教的語言選項
  def update_languages
    #沒有選擇role 直接選擇friend時 提示選擇角色
    if params[:role] == ""
      @role = "false"
      respond_to do |format|
        format.js { flash.now[:alert] = "Please select your role" }
      end
    #選擇role還未選擇friend 因是正常步驟 不做任何事
    elsif params[:friendship_id] == ""
      @role = "true"
    else
      @user = User.find(params[:friendship_id])
      if params[:role] == "teacher"
        @languages = @user.learning_languages
      else
        @languages = @user.teaching_languages
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
    url = "http://127.0.0.1:9001/api/1/getText?apikey=2113a5136cdc865146faab71c441141110311940d9c50c96080276eb6f781752&padID=#{@lesson.padID}"
    # url = "http://ilang-etherpad-lite.herokuapp.com/api/1/getText?apikey=60ab94c4ffb59abc33b3b5dcb2e92af48ac0b2544fa3d8ff3d7d172f573ee7c2&padID=#{@lesson.padID}"
    response = RestClient.get(url)
    data = JSON.parse(response.body)
    @lesson.status = "false"
    @lesson.content = data["data"]["text"]
    if @lesson.update(lesson_content_param)
      text = data["data"]["text"]
      text.to_s.split("\n").each do |vocal|
        if vocal.to_s.split(":")[1] != nil
          @tmp_vocabs = vocal.to_s.split(" ")[0]
          @tmp_key = Vocab.where("key = ?", @tmp_vocabs.to_s.split(":")[0])
          if(!@tmp_key.first)
            @vocab = @lesson.vocabs.build(vocab_params)
            @vocab.lesson_id = @lesson.id
            @vocab.language_id = @lesson.language_id
            @vocab.student_id = @lesson.student_id
            @vocab.key = @tmp_vocabs.to_s.split(":")[0]
            @vocab.value = @tmp_vocabs.to_s.split(":")[1]
            if @vocab.save
              flash[:notice] = "lesson has completed and Vocab has been saved"
            else
              flash[:alert] = @vocab.errors.full_messages.to_sentence
            end
          else
            flash[:notice] = "lesson has completed"
          end
        end
      end
      redirect_to root_path
    else
      flash[:alert] = @lesson.errors.full_messages.to_sentence
      render :action => :show
    end
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
