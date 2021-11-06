FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { 'Strong2' }
    password_confirmation { 'Strong2' }
    bio { Faker::Quote.famous_last_words }
  end
end
