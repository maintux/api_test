require 'rails_helper'

RSpec.describe "api/v1/albums/index", type: :view do
  before(:each) do
    @owner = FactoryGirl.create(:user, role: 'admin')
    @album1 = FactoryGirl.create(:album, owner_id: @owner.id)
    @album2 = FactoryGirl.create(:album, owner_id: @owner.id)
    @albums = assign(:albums, [@album1, @album2])
  end

  after :all do
    User.destroy_all
  end

  after :each do
    Album.destroy_all
  end

  it "renders a list of albums" do
    render
    json = []
    @albums.each do |a|
      json << {
        id: a.id, title: a.title, description: a.description,
        owner: {
          id: a.owner.id, name: a.owner.name, surname: a.owner.surname, email: a.owner.email
        }
      }
    end
    expect(JSON::parse(rendered)).to include_json(json)
  end
end
