require 'api_constraints'
Rails.application.routes.draw do

  # Example of curl calls
  # curl http://localhost:3111/api/ping -H 'Accept: application/vnd.api_test; version=1'
  # curl http://localhost:3111/api/users/:id/ -H 'Authorization: Token token=":token"' -H 'Accept: application/vnd.api_test; version=1'
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: false) do
      get "ping" => "base#ping"
    end
  end

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout'}

end
