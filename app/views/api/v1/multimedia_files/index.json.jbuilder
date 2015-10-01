json.array!(@multimedia_files) do |multimedia_file|
  json.extract! multimedia_file, :id, :title, :description, :album_id, :created_at, :updated_at, :type
  if multimedia_file.type.eql?('video')
    json.extract! multimedia_file, :provider, :url
  elsif multimedia_file.type.eql?('image')
    json.urls do
      json.original multimedia_file.attachment.url(:original, false)
      json.medium multimedia_file.attachment.url(:medium, false)
      json.thumb multimedia_file.attachment.url(:thumb, false)
    end
  end
  json.owner do
    json.extract! multimedia_file.owner, :id, :name, :surname, :email
  end
end
