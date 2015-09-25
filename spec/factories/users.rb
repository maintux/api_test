FactoryGirl.define do
  factory :user do
    name {Faker::Name.first_name}
    surname {Faker::Name.last_name}
    email {Faker::Internet.safe_email}
    password 'passw0rd'
    password_confirmation 'passw0rd'
  end
end
