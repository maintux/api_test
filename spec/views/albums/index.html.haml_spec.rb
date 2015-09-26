require 'rails_helper'

RSpec.describe "albums/index", type: :view do
  before(:each) do
    @album1 = FactoryGirl.create(:album, owner_id: 1)
    @album2 = FactoryGirl.create(:album, owner_id: 1)
    assign(:albums, [@album1, @album2])
  end

  it "renders a list of albums" do
    render
    assert_select "tr:first-child>td", text: @album1.title, count: 1
    assert_select "tr:first-child>td", text:  @album1.description, count: 1
    assert_select "tr:first-child>td", text: @album1.owner_id.to_s, count: 1
    assert_select "tr:last-child>td", text: @album2.title, count: 1
    assert_select "tr:last-child>td", text:  @album2.description, count: 1
    assert_select "tr:last-child>td", text: @album2.owner_id.to_s, count: 1
  end
end
