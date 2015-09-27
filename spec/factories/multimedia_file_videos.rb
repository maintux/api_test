FactoryGirl.define do
  factory :multimedia_file_video, :class => 'MultimediaFile::Video' do
    title {Faker::Lorem.word}
    description {Faker::Lorem.sentence}
    provider "youtube"
    url "https://www.youtube.com/watch?v=a1Y73sPHKxw"
  end

end
