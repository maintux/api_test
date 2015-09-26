require 'rails_helper'

RSpec.describe "albums/show", type: :view do
  before(:each) do
    @album = assign(:album, FactoryGirl.create(:album, owner_id: 1))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{@album.title}/)
    expect(rendered).to match(/#{@album.description}/)
    expect(rendered).to match(/#{@album.owner_id}/)
  end
end
