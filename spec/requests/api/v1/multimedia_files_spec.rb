require 'rails_helper'

describe "Api MultimediaFiles", type: :request do

  before :all do
    @admin = FactoryGirl.create :user, role: 'admin'
    @user = FactoryGirl.create :user, role: 'user'
    @second_user = FactoryGirl.create :user, role: 'user'
    @guest = FactoryGirl.create :user, role: 'guest'
  end

  after :all do
    User.destroy_all
  end

  after :each do
    Album.destroy_all
    MultimediaFile::Video.destroy_all
  end

  describe "GET /api/v1/multimedia_files" do

    it "Must send Accept header" do
      expect { get api_multimedia_files_path }.to raise_error(ActionController::RoutingError)
    end

    it "Must be authenticated" do
      headers = {}
      headers['Accept'] = "application/vnd.api_test; version=1"
      get api_multimedia_files_path, nil, headers
      expect(response).to have_http_status(401)
      get api_multimedia_files_path, nil, auth_headers_for(@guest)
      expect(response).to have_http_status(200)
    end

    it "Prevent tampering" do
      headers = {}
      headers['Accept'] = "application/vnd.api_test; version=1"
      headers['Authorization'] = "Token token=\"teampered_token\""
      get api_multimedia_files_path, nil, headers
      expect(response).to have_http_status(401)
    end

    it "Return multimedia_files for all user roles" do
      get api_multimedia_files_path, nil, auth_headers_for(@guest)
      expect(response).to have_http_status(200)
      get api_multimedia_files_path, nil, auth_headers_for(@user)
      expect(response).to have_http_status(200)
      get api_multimedia_files_path, nil, auth_headers_for(@admin)
      expect(response).to have_http_status(200)
    end

  end

  describe "GET /api/v1/multimedia_files/:id" do

    it "Ensure multimedia_file type was provided" do
      album = FactoryGirl.create :album, owner_id: @user.id
      multimedia_file = FactoryGirl.create :multimedia_file_video, owner_id: @user.id, album_id: album.id
      @user.reload
      expect(@user.albums.count).to eq(1)
      expect(@user.multimedia_files.count).to eq(1)
      get api_multimedia_file_path(multimedia_file), nil, auth_headers_for(@guest)
      expect(response).to have_http_status(422)
      expect(response.body).to eq({error: "Unprocessable entity", status: 422}.to_json)
      get api_multimedia_file_path(multimedia_file, type: 'video'), nil, auth_headers_for(@guest)
      expect(response).to have_http_status(200)
    end

  end

  describe "POST /api/v1/multimedia_files" do

    it "Prevent create multimedia_file for guest" do
      album = FactoryGirl.create :album, owner_id: @user.id
      multimedia_file = FactoryGirl.build :multimedia_file_video, album_id: album.id
      post api_multimedia_files_path, make_http_params_from(multimedia_file), auth_headers_for(@guest)
      expect(response).to have_http_status(401)
      expect(response.body).to eq({error: "Unauthorized", status: 401}.to_json)
    end

    it "Ensure user can create multimedia_files" do
      album = FactoryGirl.create :album, owner_id: @user.id
      multimedia_file = FactoryGirl.build :multimedia_file_video, album_id: album.id
      post api_multimedia_files_path, make_http_params_from(multimedia_file), auth_headers_for(@user)
      expect(response).to have_http_status(422)
      expect(response.body).to eq({error: "Unprocessable entity", status: 422}.to_json)
      post api_multimedia_files_path(type: 'video'), make_http_params_from(multimedia_file), auth_headers_for(@user)
      expect(response).to have_http_status(200)
      expect(@user.multimedia_files.count).to eq(1)
    end

    it "Ensure user can create multimedia_file only in his albums" do
      album = FactoryGirl.create :album, owner_id: @second_user.id
      multimedia_file = FactoryGirl.build :multimedia_file_video, owner_id: @user.id
      multimedia_file.album_id = album.id
      post api_multimedia_files_path(type: 'video'), make_http_params_from(multimedia_file), auth_headers_for(@user)
      expect(response).to have_http_status(422)
      expect(response.body).to eq('{"album_id":["is invalid"]}')
    end

    it "Ensure admin can create multimedia_files" do
      album = FactoryGirl.create :album, owner_id: @admin.id
      multimedia_file = FactoryGirl.build :multimedia_file_video, album_id: album.id
      post api_multimedia_files_path(type: 'video'), make_http_params_from(multimedia_file), auth_headers_for(@admin)
      expect(response).to have_http_status(200)
      expect(@admin.multimedia_files.count).to eq(1)
    end

  end

  describe "PATCH /api/v1/multimedia_files/:id" do

    it "Ensure user can modify only his albums" do
      album = FactoryGirl.create :album, owner_id: @user.id
      multimedia_file = FactoryGirl.create :multimedia_file_video, album_id: album.id, owner_id: @user.id
      old_title = multimedia_file.title
      patch api_multimedia_file_path(multimedia_file), {multimedia_file_video: {title: "My new title"}}, auth_headers_for(@second_user)
      expect(response).to have_http_status(422)
      multimedia_file.reload
      expect(multimedia_file.title).to eq(old_title)
      patch api_multimedia_file_path(multimedia_file, type: 'video'), {multimedia_file_video: {title: "My new title"}}, auth_headers_for(@second_user)
      expect(response).to have_http_status(401)
      multimedia_file.reload
      expect(multimedia_file.title).to eq(old_title)
      expect(response.body).to eq({error: "Unauthorized", status: 401}.to_json)
      patch api_multimedia_file_path(multimedia_file, type: 'video'), {multimedia_file_video: {title: "My new title"}}, auth_headers_for(@user)
      expect(response).to have_http_status(200)
      multimedia_file.reload
      expect(multimedia_file.title).to eq("My new title")
    end

    it "Ensure admin can modify all albums" do
      album = FactoryGirl.create :album, owner_id: @user.id
      multimedia_file = FactoryGirl.create :multimedia_file_video, album_id: album.id, owner_id: @user.id
      patch api_multimedia_file_path(multimedia_file, type: 'video'), {multimedia_file_video: {title: "My new title"}}, auth_headers_for(@admin)
      expect(response).to have_http_status(200)
      multimedia_file.reload
      expect(multimedia_file.title).to eq("My new title")
    end

  end

  describe "DELETE /api/v1/multimedia_files/:id" do

    it "Ensure user can delete only his multimedia_files" do
      album = FactoryGirl.create :album, owner_id: @user.id
      multimedia_file = FactoryGirl.create :multimedia_file_video, album_id: album.id, owner_id: @user.id
      @user.reload
      expect(@user.albums.count).to eq(1)
      expect(@user.multimedia_files.count).to eq(1)
      delete api_multimedia_file_path(multimedia_file), nil, auth_headers_for(@second_user)
      expect(response).to have_http_status(422)
      expect(@user.multimedia_files.count).to eq(1)
      delete api_multimedia_file_path(multimedia_file, type: 'video'), nil, auth_headers_for(@second_user)
      expect(response).to have_http_status(401)
      expect(@user.multimedia_files.count).to eq(1)
      expect(response.body).to eq({error: "Unauthorized", status: 401}.to_json)
      delete api_multimedia_file_path(multimedia_file), nil, auth_headers_for(@user)
      expect(response).to have_http_status(422)
      expect(@user.albums.count).to eq(1)
      expect(@user.multimedia_files.count).to eq(1)
      delete api_multimedia_file_path(multimedia_file, type: 'video'), nil, auth_headers_for(@user)
      expect(response).to have_http_status(204)
      @user.reload
      expect(@user.multimedia_files.count).to eq(0)
    end

    it "Ensure admin can delete all multimedia_files" do
      album = FactoryGirl.create :album, owner_id: @user.id
      multimedia_file = FactoryGirl.create :multimedia_file_video, album_id: album.id, owner_id: @user.id
      @user.reload
      expect(@user.albums.count).to eq(1)
      expect(@user.multimedia_files.count).to eq(1)
      delete api_multimedia_file_path(multimedia_file), nil, auth_headers_for(@admin)
      expect(response).to have_http_status(422)
      expect(@user.albums.count).to eq(1)
      expect(@user.multimedia_files.count).to eq(1)
      delete api_multimedia_file_path(multimedia_file, type: 'video'), nil, auth_headers_for(@admin)
      expect(response).to have_http_status(204)
      @user.reload
      expect(@user.multimedia_files.count).to eq(0)
    end

  end
end
