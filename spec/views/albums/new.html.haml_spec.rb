require 'rails_helper'

RSpec.describe "albums/new", type: :view do
  before(:each) do
    assign(:album, FactoryGirl.build(:album))
  end

  it "renders new album form" do
    render
    assert_select "form[action=?][method=?]", albums_path, "post" do
      assert_select "input#album_title[name=?]", "album[title]"
      assert_select "textarea#album_description[name=?]", "album[description]"
    end
  end
end
