require 'rails_helper'

RSpec.describe "albums/index", type: :view do
  before(:each) do
    @owner = FactoryGirl.create(:user, role: 'admin')
    @album1 = FactoryGirl.create(:album, owner_id: @owner.id)
    @album2 = FactoryGirl.create(:album, owner_id: @owner.id)
    assign(:albums, [@album1, @album2])
  end

  it "renders a list of albums" do
    render
    assert_select "tr:first-child>td", text: @album1.title, count: 1
    assert_select "tr:first-child>td", text:  @album1.description, count: 1
    assert_select "tr:first-child>td", text: @owner.full_name, count: 1
    assert_select "tr:last-child>td", text: @album2.title, count: 1
    assert_select "tr:last-child>td", text:  @album2.description, count: 1
    assert_select "tr:last-child>td", text: @owner.full_name, count: 1
  end
end
