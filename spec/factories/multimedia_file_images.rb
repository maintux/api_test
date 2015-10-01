FactoryGirl.define do

  factory :multimedia_file_image, :class => 'MultimediaFile::Image' do
    title {Faker::Lorem.word}
    description {Faker::Lorem.sentence}
    attachment { fixture_file_upload(Rails.root.join('spec', 'support', 'api', 'image.jpg'), 'image/jpg') }
  end

end
