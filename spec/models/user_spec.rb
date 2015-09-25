require 'rails_helper'

describe User, type: :model do

  after :each do
    User.destroy_all
  end

  it "Creates user with an api_key" do
    user = FactoryGirl.create :user, role: 'admin'
    expect(user).not_to be_a_new(User)
    expect(user.admin?).to be_truthy
    expect(user.api_key).not_to be_nil
  end

end
