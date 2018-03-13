namespace :dev do
	task fake_languages: :environment do 
		Language.destroy_all
		20.times do |l|
			name = FFaker::Locale::language
			Language.create!(
				name: name
			)
			puts "Language #{name} is created"
		end
		puts "Totally #{Language.count} languages have been created"
	end


end