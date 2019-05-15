class OpenWeatherMap
  def initialize
    @json_client = JSONClient.new('https://api.openweathermap.org')
    @json_client.authenticate("cbe7de6d147912e998501c064c7d1dc4")
  end
  
  def search(phrase)
    json = @json_client.get '/data/2.5/weather?q=', phrase
  end
end