FactoryGirl.define do

  factory :album do
    title {Faker::Lorem.word}
    description {Faker::Lorem.sentence}
  end

end
