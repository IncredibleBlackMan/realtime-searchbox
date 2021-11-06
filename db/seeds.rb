# frozen_string_literal: true

require 'faker'

puts '== Seeding the database =='

puts '== Creating users =='

10.times do |i|
  user = User.create!(
    email: "example#{i + 1}@helpjuice.com",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    bio: Faker::Quote.famous_last_words,
    password: 'pass1234',
    password_confirmation: 'pass1234'
  )

end

puts '== Creatings articles =='

50.times do
  Article.create(
    user_id: [*1..10].sample,
    title: Faker::Lorem.sentence,
    introduction: Faker::Lorem.paragraph(sentence_count: 8),
    content: Faker::Lorem.paragraph(sentence_count: 40)
  )
end
