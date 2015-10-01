require 'rails_helper'

describe "Api Albums", type: :request do

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
  end

  describe "GET /api/v1/albums" do

    it "Must send Accept header" do
      expect { get api_albums_path }.to raise_error(ActionController::RoutingError)
    end

    it "Must be authenticated" do
      headers = {}
      headers['Accept'] = "application/vnd.api_test; version=1"
      get api_albums_path, nil, headers
      expect(response).to have_http_status(401)
      get api_albums_path, nil, auth_headers_for(@guest)
      expect(response).to have_http_status(200)
    end

    it "Prevent tampering" do
      headers = {}
      headers['Accept'] = "application/vnd.api_test; version=1"
      headers['Authorization'] = "Token token=\"teampered_token\""
      get api_albums_path, nil, headers
      expect(response).to have_http_status(401)
    end

    it "Return albums for all user roles" do
      get api_albums_path, nil, auth_headers_for(@guest)
      expect(response).to have_http_status(200)
      get api_albums_path, nil, auth_headers_for(@user)
      expect(response).to have_http_status(200)
      get api_albums_path, nil, auth_headers_for(@admin)
      expect(response).to have_http_status(200)
    end

  end

  describe "POST /api/v1/albums" do

    it "Prevent create album for guest" do
      album = FactoryGirl.build :album
      post api_albums_path, make_http_params_from(album), auth_headers_for(@guest)
      expect(response).to have_http_status(401)
      expect(JSON::parse(response.body)).to include_json({error: "Unauthorized", status: 401})
    end

    it "Ensure user can create albums" do
      album = FactoryGirl.build :album
      post api_albums_path, make_http_params_from(album), auth_headers_for(@user)
      expect(response).to have_http_status(200)
      hash = Album.last.attributes.reject{|k,v| ["owner_id","created_at", "updated_at"].include?(k)}.merge({"owner" => @user.attributes.keep_if{|k,v| ['id', 'name', 'surname', 'email'].include?(k)}})
      expect(JSON::parse(response.body)).to include_json(hash)
    end

    it "Ensure admin can create albums" do
      album = FactoryGirl.build :album
      post api_albums_path, make_http_params_from(album), auth_headers_for(@admin)
      expect(response).to have_http_status(200)
      hash = Album.last.attributes.reject{|k,v| ["owner_id","created_at", "updated_at"].include?(k)}.merge({"owner" => @admin.attributes.keep_if{|k,v| ['id', 'name', 'surname', 'email'].include?(k)}})
      expect(JSON::parse(response.body)).to include_json(hash)
    end

  end

  describe "GET /api/v1/albums/:id" do

    it "Ensure user can modify only his albums" do
      album = FactoryGirl.create :album, owner_id: @user.id
      old_title = album.title
      patch api_album_path(album), {album: {title: "My new title"}}, auth_headers_for(@second_user)
      expect(response).to have_http_status(401)
      album.reload
      expect(album.title).to eq(old_title)
      expect(response.body).to eq({error: "Unauthorized", status: 401}.to_json)
      patch api_album_path(album), {album: {title: "My new title"}}, auth_headers_for(@user)
      expect(response).to have_http_status(200)
      album.reload
      expect(album.title).to eq("My new title")
      hash = Album.last.attributes.reject{|k,v| ["owner_id","created_at", "updated_at"].include?(k)}.merge({"owner" => @user.attributes.keep_if{|k,v| ['id', 'name', 'surname', 'email'].include?(k)}})
      expect(JSON::parse(response.body)).to include_json(hash)
    end
  end

  describe "PATCH /api/v1/albums/:id" do

    it "Ensure user can modify only his albums" do
      album = FactoryGirl.create :album, owner_id: @user.id
      old_title = album.title
      patch api_album_path(album), {album: {title: "My new title"}}, auth_headers_for(@second_user)
      expect(response).to have_http_status(401)
      album.reload
      expect(album.title).to eq(old_title)
      expect(response.body).to eq({error: "Unauthorized", status: 401}.to_json)
      patch api_album_path(album), {album: {title: "My new title"}}, auth_headers_for(@user)
      expect(response).to have_http_status(200)
      album.reload
      expect(album.title).to eq("My new title")
      hash = Album.last.attributes.reject{|k,v| ["owner_id","created_at", "updated_at"].include?(k)}.merge({"owner" => @user.attributes.keep_if{|k,v| ['id', 'name', 'surname', 'email'].include?(k)}})
      expect(JSON::parse(response.body)).to include_json(hash)
    end

    it "Ensure admin can modify all albums" do
      album = FactoryGirl.create :album, owner_id: @user.id
      patch api_album_path(album), {album: {title: "My new title"}}, auth_headers_for(@admin)
      expect(response).to have_http_status(200)
      album.reload
      expect(album.title).to eq("My new title")
      hash = Album.last.attributes.reject{|k,v| ["owner_id","created_at", "updated_at"].include?(k)}.merge({"owner" => @user.attributes.keep_if{|k,v| ['id', 'name', 'surname', 'email'].include?(k)}})
      expect(JSON::parse(response.body)).to include_json(hash)
    end

  end

  describe "DELETE /api/v1/albums/:id" do

    it "Ensure user can delete only his albums" do
      album = FactoryGirl.create :album, owner_id: @user.id
      expect(Album.count).to eq(1)
      delete api_album_path(album), nil, auth_headers_for(@second_user)
      expect(response).to have_http_status(401)
      expect(Album.count).to eq(1)
      expect(response.body).to eq({error: "Unauthorized", status: 401}.to_json)
      delete api_album_path(album), nil, auth_headers_for(@user)
      expect(response).to have_http_status(204)
      expect(Album.count).to eq(0)
    end

    it "Ensure admin can delete all albums" do
      album = FactoryGirl.create :album, owner_id: @user.id
      expect(Album.count).to eq(1)
      delete api_album_path(album), nil, auth_headers_for(@admin)
      expect(response).to have_http_status(204)
      expect(Album.count).to eq(0)
    end

  end
end
