class JSONClient
  def initialize(root_url)
    @root_url = root_url 
  end
  
  def get(path, param)
    response = connection.get path + param +'&APPID=' + @authentication do |request|
      request.headers["Content-Type"] = "application/json"
    end
    
    body = response.body
    json = JSON.parse(body)
    json
  end
  
  def authenticate(key) 
    @authentication = key
  end
  
  private 
  
  def connection
    @connection ||= Faraday.new(:url => @root_url) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end
  end
end
