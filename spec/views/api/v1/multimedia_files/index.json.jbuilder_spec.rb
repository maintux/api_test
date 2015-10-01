require 'rails_helper'

RSpec.describe "api/v1/multimedia_files/index", type: :view do
  before(:each) do
    @owner = FactoryGirl.create(:user, role: 'admin')
    @album = FactoryGirl.create(:album, owner_id: @owner.id)
    @video = FactoryGirl.create(:multimedia_file_video, owner_id: @owner.id, album_id: @album.id)
    @image = FactoryGirl.create(:multimedia_file_image, owner_id: @owner.id, album_id: @album.id)
    @multimedia_files = assign(:multimedia_files, [@video, @image])
  end

  after :all do
    User.destroy_all
  end

  after :each do
    Album.destroy_all
    MultimediaFile::Image.destroy_all
    MultimediaFile::Video.destroy_all
  end

  it "renders a list of multimedia files" do
    render
    json = []
    @multimedia_files.each do |mf|
      _h = {
        id: mf.id, title: mf.title, description: mf.description, album_id: mf.album_id, type: mf.type,
        owner: {
          id: mf.owner.id, name: mf.owner.name, surname: mf.owner.surname, email: mf.owner.email
        }
      }
      if mf.type.eql?"video"
        _h[:provider] = mf.provider
        _h[:url] = mf.url
      elsif mf.type.eql?"image"
        _h[:urls] = {
          original: mf.attachment.url(:original, false),
          medium: mf.attachment.url(:medium, false),
          thumb: mf.attachment.url(:thumb, false)
        }
      end
      json << _h
    end
    expect(JSON::parse(rendered)).to include_json(json)
  end
end
