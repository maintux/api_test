json.array!(@albums) do |album|
  json.extract! album, :id, :title, :description, :created_at, :updated_at
  json.owner do
    json.extract! album.owner, :id, :name, :surname, :email
  end
  json.url album_url(album)
end
