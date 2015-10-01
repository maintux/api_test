require 'rails_helper'

RSpec.describe "api/v1/multimedia_files/show", type: :view do

  before(:each) do
    @owner = FactoryGirl.create(:user, role: 'admin')
    @album = FactoryGirl.create(:album, owner_id: @owner.id)
    @video = FactoryGirl.create(:multimedia_file_video, owner_id: @owner.id, album_id: @album.id)
    @image = FactoryGirl.create(:multimedia_file_image, owner_id: @owner.id, album_id: @album.id)
  end

  after :all do
    User.destroy_all
  end

  after :each do
    Album.destroy_all
    MultimediaFile::Image.destroy_all
    MultimediaFile::Video.destroy_all
  end

  it "renders image" do
    assign(:multimedia_file, @image)
    render
    json = {
      id: @image.id, title: @image.title, description: @image.description, album_id: @image.album_id, type: @image.type,
      owner: {
        id: @image.owner.id, name: @image.owner.name, surname: @image.owner.surname, email: @image.owner.email
      },
      urls: {
        original: @image.attachment.url(:original, false),
        medium: @image.attachment.url(:medium, false),
        thumb: @image.attachment.url(:thumb, false)
      }
    }
    expect(JSON::parse(rendered)).to include_json(json)
  end

  it "renders video" do
    assign(:multimedia_file, @video)
    render
    json = {
      id: @video.id,
      title: @video.title,
      description: @video.description,
      album_id: @video.album_id,
      type: @video.type,
      provider: @video.provider,
      url: @video.url,
      owner: {
        id: @video.owner.id, name: @video.owner.name, surname: @video.owner.surname, email: @video.owner.email
      }
    }
    expect(JSON::parse(rendered)).to include_json(json)
  end

end
