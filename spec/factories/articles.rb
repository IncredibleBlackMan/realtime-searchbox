FactoryBot.define do
  factory :article do
    title { Faker::Lorem.sentence }
    introduction { Faker::Lorem.paragraph(sentence_count: 3) }
    content { Faker::Lorem.paragraph(sentence_count: 5) }

    association :user
  end
end
