# api_test
API server for a simple media gallery

## Setup
* clone repo
* run `bundle install`
* run `rake db:migrate`
* run `rails s`

## Usage
This app provides three user levels: Admin, User and Guest. So with a migrations the app creates an user for each level with the same password: passw0rd.
You can find the api_key by logging in to the web panel using the user that you prefer.
So you can consume the APIs through a custom client. Here some example with curl:

```
# Get albums list
curl http://localhost:3000/api/albums/ \
    -H 'Authorization: Token token="your_api_key"' \
    -H 'Accept: application/vnd.api_test; version=1'

# Create album
curl http://localhost:3000/api/albums/ \
    -H 'Authorization: Token token="your_api_key"' \
    -H 'Accept: application/vnd.api_test; version=1' -X POST \
    -F "album[title]=TestAPI" \
    -F "album[description]=Lorem ipsum Aute officia exercitation veniam aliqua in."

# Edit album
curl http://localhost:3000/api/albums/1 \
    -H 'Authorization: Token token="your_api_key"' \
    -H 'Accept: application/vnd.api_test; version=1' -X PATCH \
    -F "album[title]=NewTestAPI"

# Delete album
curl http://localhost:3000/api/albums/1 -H 'Authorization: Token token="your_api_key"' \
    -H 'Accept: application/vnd.api_test; version=1' -X DELETE
```

```
# Get multimedia files list
curl http://localhost:3000/api/multimedia_files/ \
    -H 'Authorization: Token token="your_api_key"' \
    -H 'Accept: application/vnd.api_test; version=1'

# Get multimedia files list by album
curl http://localhost:3000/api/album/1/multimedia_files/ \
    -H 'Authorization: Token token="your_api_key"' \
    -H 'Accept: application/vnd.api_test; version=1'

# Get multimedia file (video)
curl http://localhost:3000/api/multimedia_files/1?type=video \
    -H 'Authorization: Token token="your_api_key"' \
    -H 'Accept: application/vnd.api_test; version=1'

# Get multimedia file (image)
curl http://localhost:3000/api/multimedia_files/1?type=image \
    -H 'Authorization: Token token="your_api_key"' \
    -H 'Accept: application/vnd.api_test; version=1'

# Create multimedia file (video)
curl http://localhost:3000/api/multimedia_files/?type=video \
    -H 'Authorization: Token token="your_api_key"' \
    -H 'Accept: application/vnd.api_test; version=1' -X POST \
    -F "multimedia_file_video[title]=TestAPI" \
    -F "multimedia_file_video[album_id]=1" \
    -F "multimedia_file_video[provider]=youtube" \
    -F "multimedia_file_video[url]=https://www.youtube.com/watch?v=a1Y73sPHKxw"

# Create multimedia file (image)
curl http://localhost:3000/api/multimedia_files/?type=image \
    -H 'Authorization: Token token="your_api_key"' \
    -H 'Accept: application/vnd.api_test; version=1' -X POST \
    -F "multimedia_file_image[title]=TestAPI" \
    -F "multimedia_file_image[album_id]=1" \
    -F "multimedia_file_image[attachment]=@/your/image/file.jpg"

# Edit multimedia file (video)
curl http://localhost:3000/api/multimedia_files/1?type=video \
    -H 'Authorization: Token token="your_api_key"' \
    -H 'Accept: application/vnd.api_test; version=1' -X PATCH \
    -F "multimedia_file_video[title]=NewTestAPI"

# Edit multimedia file (image)
curl http://localhost:3000/api/multimedia_files/1?type=image \
    -H 'Authorization: Token token="your_api_key"' \
    -H 'Accept: application/vnd.api_test; version=1' -X PATCH \
    -F "multimedia_file_image[title]=NewTestAPI"

# Delete multimedia file (video)
curl http://localhost:3000/api/albums/1?type=video \
    -H 'Authorization: Token token="your_api_key"' \
    -H 'Accept: application/vnd.api_test; version=1' -X DELETE

# Delete multimedia file (image)
curl http://localhost:3000/api/albums/1?type=image \
    -H 'Authorization: Token token="your_api_key"' \
    -H 'Accept: application/vnd.api_test; version=1' -X DELETE
```

## Pagination
This app use api pagination with HTTP Headers. This follows the proposed [RFC-5988](http://tools.ietf.org/html/rfc5988) standard for Web linking.
So in resposne headers you can find information about paginator status:

```
Link: <http://localhost:3000/api/albums/?page=2>; rel="last", <http://localhost:3000/api/albums/?page=2>; rel="next"
X-Total: 22
X-Per-Page: 10
```

## Testing
To run the test suite jsut use: `bundle exec rspec`