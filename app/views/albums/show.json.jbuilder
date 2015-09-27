json.extract! @album, :id, :title, :description, :created_at, :updated_at
json.owner do
  json.extract! @album.owner, :id, :email, :name, :surname
end