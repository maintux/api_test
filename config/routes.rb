require 'api_constraints'
Rails.application.routes.draw do

  resources :albums

  # Example of curl calls
  # curl http://localhost:3111/api/ping -H 'Accept: application/vnd.api_test; version=1'
  # curl http://localhost:3111/api/users/:id/ -H 'Authorization: Token token=":token"' -H 'Accept: application/vnd.api_test; version=1'
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: false) do
      get "ping" => "base#ping"
      resources :albums, except: [:new, :edit]
    end
  end

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout'}

  root to: "albums#index"

end
