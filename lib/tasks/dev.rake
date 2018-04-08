namespace :dev do
	task fake_languages: :environment do 
		Language.destroy_all
		Language.create!(
			name: "中文"
		)
		Language.create!(
      name: "英文"
    )
    Language.create!(
      name: "日文"
    )
    Language.create!(
      name: "德文"
    )
    Language.create!(
      name: "法文"
    )
    Language.create!(
      name: "西班牙文"
    )
    Language.create!(
      name: "韓文"
    )
		puts "Totally #{Language.count} languages have been created"
	end

	task fake_users: :environment do
		User.destroy_all
    20.times do |i|
      user_name = FFaker::Name.first_name
      file = File.open("#{Rails.root}/public/avatar/user#{i+1}.jpg")
      client = FilestackClient.new('A6SyNX4ymRHOey4eMSXThz')
      filelink = client.upload(filepath: file, multipart: false)
      User.create!(
        username: user_name,
        email: "#{user_name}@example.com",
        password: "12345678",
        avatar: filelink.url
      )
    end

    puts "have created fake users"
    puts "now you have #{User.count} users data"
  end

 	task fake_teachings: :environment do
 		Teaching.destroy_all
    Language.all.each do |language|
      10.times do |i|
        language.teachings.create(
          user: User.all.sample
          )
      end
    end

    puts "have created fake teachings"
    puts "now you have #{Teaching.count} teaching data"
  end

  task fake_learnings: :environment do
 		Learning.destroy_all
    Language.all.each do |language|
      10.times do |i|
        language.learnings.create(
          user: User.all.sample
          )
      end
    end

    puts "have created fake learnings"
    puts "now you have #{Learning.count} learnings data"
  end


  task fake_friendships: :environment do
    Friendship.destroy_all
    User.all.each do |user|
      rand(1..10).times do
        user.friendships.create(
          friending_id: User.where.not(id: user.id).sample.id
        )
      end
    end

    puts "have created fake friendships"
    puts "now you have #{Learning.count} friendships data"
  end

  task fake_lessons: :environment do
    Lesson.destroy_all
    20.times do |i|
      chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
      randomstring = ''
      10.times { randomstring << chars[rand(chars.size)] }
      Lesson.create!(
        title: "fake lesson",
        status: false,
        teacher_id: User.all.sample.id,
        student_id: User.all.sample.id,
        language: Language.all.sample,
        padID: randomstring
      )
    end
    puts "Totally #{Lesson.count} lessons are created"
  end

  task fake_vocabs: :environment do
    Vocab.destroy_all
    500.times do |i|
      Vocab.create!(
        language: Language.all.sample,
        student_id: User.all.sample.id,
        lesson: Lesson.all.sample,
        key: FFaker::LoremKR::word,
        value: FFaker::LoremCN::word
      )

    end
    puts "Totally #{Vocab.count} vocabs are created"
  end

  task :rebuild_dev do
    Rake::Task["dev:fake_users"].invoke
    Rake::Task["dev:fake_languages"].invoke
    Rake::Task["dev:fake_teachings"].invoke
    Rake::Task["dev:fake_learnings"].invoke
    Rake::Task["dev:fake_friendships"].invoke
    Rake::Task["dev:fake_lessons"].invoke
    Rake::Task["dev:fake_vocabs"].invoke
  end

  task update_logo: :environment do
    file = File.open("#{Rails.root}/public/logo.png")
    client = FilestackClient.new('A6SyNX4ymRHOey4eMSXThz')
    client.upload(filepath: file, multipart: false)

    puts "update logo pic"
  end

  task update_profile: :environment do
    file = File.open("#{Rails.root}/public/profile.png")
    client = FilestackClient.new('A6SyNX4ymRHOey4eMSXThz')
    client.upload(filepath: file, multipart: false)

    puts "update profile pic"
  end  
end
