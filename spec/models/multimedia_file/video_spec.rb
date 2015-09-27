require 'rails_helper'

RSpec.describe MultimediaFile::Video, type: :model do

  before :all do
    @admin = FactoryGirl.create :user, role: 'admin'
    @user = FactoryGirl.create :user, role: 'user'
    @second_user = FactoryGirl.create :user, role: 'user'
    @user_album = FactoryGirl.create :album, owner_id: @user.id
    @second_user_album = FactoryGirl.create :album, owner_id: @second_user.id
  end

  it "Ensure user can create multimedia_file only in his albums" do
    multimedia_file = FactoryGirl.build :multimedia_file_video, owner_id: @user.id
    multimedia_file.album_id = @second_user_album.id
    expect(multimedia_file.valid?).not_to be_truthy
    expect(multimedia_file.errors[:album_id].size).to eq(1)
    multimedia_file.album_id = @user_album.id
    expect(multimedia_file.valid?).to be_truthy
  end

  it "Ensure admin can create multimedia_file wherever he want" do
    multimedia_file = FactoryGirl.build :multimedia_file_video, owner_id: @admin.id
    multimedia_file.album_id = @second_user_album.id
    expect(multimedia_file.valid?).to be_truthy
  end

end
