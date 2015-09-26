def auth_headers_for(user, version=1)
  headers = {}
  headers['Accept'] = "application/vnd.api_test; version=#{version}"
  headers['Authorization'] = "Token token=\"#{user.try(:api_key)}\""
  headers
end

def make_http_params_from(obj)
  params = {}
  params[obj.class.to_s.downcase] = {}
  obj.attributes.each do |k,v|
    params[obj.class.to_s.downcase][k] = v unless v.nil?
  end
  params
end