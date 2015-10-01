require 'rails_helper'

RSpec.describe "api/v1/albums/show", type: :view do

  before(:each) do
    @owner = FactoryGirl.create(:user, role: 'admin')
    @album = assign(:album, FactoryGirl.create(:album, owner_id: @owner.id))
  end

  after :all do
    User.destroy_all
  end

  after :each do
    Album.destroy_all
  end

  it "renders album" do
    render
    json = {
      id: @album.id, title: @album.title, description: @album.description,
      owner: {
        id: @album.owner.id, name: @album.owner.name, surname: @album.owner.surname, email: @album.owner.email
      }
    }
    expect(JSON::parse(rendered)).to include_json(json)
  end

end
