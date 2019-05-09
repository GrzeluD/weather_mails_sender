require "faraday"
require "awesome_print"
require "json"

def f_to_c f
  celsius = (f - 32)/1.8
  return celsius.round(1)
end

api_key = "cbe7de6d147912e998501c064c7d1dc4"
conn = Faraday.new(:url => 'https://api.openweathermap.org') do |faraday|
  faraday.request  :url_encoded
  faraday.adapter  Faraday.default_adapter
end

response = conn.get '/data/2.5/weather?units=imperial&lat=50.135&lon=19.632&APPID=' + api_key do |request|
  request.headers["Content-Type"] = "application/json"
end
body = response.body
json = JSON.parse(body)

main = json["main"]

name = json["name"]
weather_description = json["weather"].first["description"]
min_temp = f_to_c(main["temp_min"])
max_temp = f_to_c(main["temp_max"])
temp = f_to_c(main["temp"])
pressure = main["pressure"]
humidity = main["humidity"]
wind_speed = json["wind"]["speed"]
puts wind_speed
puts "Temperatura dla miasta #{name} wynosi #{temp} stopni Celcjusza(od #{min_temp} do #{max_temp})"

ap json
