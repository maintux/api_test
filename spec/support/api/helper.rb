def auth_headers_for(user, version=1)
  headers = {}
  headers['Accept'] = "application/vnd.api_test; version=#{version}"
  headers['Authorization'] = "Token token=\"#{user.try(:api_key)}\""
  headers
end

def make_http_params_from(obj)
  params = {}
  key = obj.class.to_s.underscore.gsub('/','_')
  params[key] = {}
  obj.attributes.each do |k,v|
    params[key][k] = v unless v.nil?
  end
  params
end