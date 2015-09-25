class ApiConstraints
  ACTIVE_API_VERSIONS = ['v1']

  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    if req.headers['Accept'] =~ /application\/vnd.api_test; version=([0-9]+)/
      ver = $1.to_i
      ACTIVE_API_VERSIONS.include?("v#{ver}") ? @version.eql?(ver) : @default
    else
      @default
    end
  end
end