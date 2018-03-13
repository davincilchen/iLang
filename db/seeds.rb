# Language

Language.destroy_all

language_list =[
  { name: "English" },
  { name: "Chinese" },
  { name: "Japanese" },
  { name: "German" },
  { name: "French" },
  { name: "Spanish" },
]

language_list.each do |language|
  Language.create( name: language[:name] )
end
puts "Language created!"