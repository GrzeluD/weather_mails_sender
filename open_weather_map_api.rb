require "faraday"
require "awesome_print"
require "json"
require "pony"
require "easy_translate"

def f_to_c f
  celsius = (f - 32)/1.8
  return celsius.round(1)
end

def translation word
  case word
  when "shower rain"
    "Mżawka"
  when "clear sky"
    "Bezchmurnie"
  when "few clouds"
    "Małe zachmurzenie"
  when "scattered clouds"
    "Zachmurzenie"
  when "broken clouds"
    "Załamanie chmury"
  when "rain"
    "Deszcz"
  when "thunderstorm"
    "Burza"
  when "snow"
    "Śnieg"
  when "mist"
    "Mgła"
  else 
    word
  end
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
icon = json["weather"].first["icon"]
icon_src = "http://openweathermap.org/img/w/" + icon + ".png"
min_temp = f_to_c(main["temp_min"])
max_temp = f_to_c(main["temp_max"])
temp = f_to_c(main["temp"])
pressure = main["pressure"]
humidity = main["humidity"]
wind_speed = json["wind"]["speed"]
clouds = json["clouds"]["all"]
time = Time.new
current_time = "#{time.hour}:#{time.min} #{time.day}.#{time.month}.#{time.year}"

message_html = "<h2 style='text-align: center'>Pogoda dla miasta #{name}</h2><br><img src=#{icon_src} width='50' height ='50'><p>Opady: #{translation(weather_description)}</p><p>Temperatura: #{temp} stopni Celsjusza(od #{min_temp} do #{max_temp})</p><p>Cisnienie: #{pressure}hpa</p><p>Predkość wiatru: #{wind_speed}mph</p><p>Wilgotność powietrza: #{humidity}%</p><p>Zachmurzenie: #{clouds}%</p>"

Pony.mail({
  :to => 'grzeluud@gmail.com',
  :subject => 'Pogoda ' + current_time ,
  :html_body => 
    '<header>
      <h1 style="text-align: center">GrzeluBot v1.0</h1>
     </header>
     <main style="line-height: 1.5">
        ' + message_html + '
     </main>
     <footer style="text-align: center; box-sizing: border-box; padding-top: 32px;" >
      Wiadomość wygenerowana przez GrzeluBot, Pozdrawiam
     </footer>',
  :via => :smtp,
  :charset => "UTF-8",
  :via_options => {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => 'grzelubot@gmail.com',
    :password             => 'Grzelubot1@3',
    :authentication       => :plain, 
    :domain               => "localhost.localdomain"
  }
})
