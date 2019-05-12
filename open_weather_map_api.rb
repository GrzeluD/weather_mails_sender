require "faraday"
require "awesome_print"
require "json"
require "pony"

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

json_client = JSONClient.new('https://api.openweathermap.org')
json_client.authenticate("cbe7de6d147912e998501c064c7d1dc4")


def to_celcius d
  if d < 60
    celcius = (d - 32)/1.8
  else
    celcius = (d - 273.15)
  end
  celcius.round(1)
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
    "Załamane chmury"
  when "rain"
    "Deszcz"
  when "thunderstorm"
    "Burza"
  when "snow"
    "Śnieg"
  when "mist"
    "Mgła"
  when "haze"
    "Mgła"
  else 
    word
  end
end

json = json_client.get '/data/2.5/weather?q=', "krzeszowice"

name = json["name"]
weather_description = json["weather"].first["description"]
icon = json["weather"].first["icon"]
icon_src = "http://openweathermap.org/img/w/" + icon + ".png"
min_temp = to_celcius(json["main"]["temp_min"])
max_temp = to_celcius(json["main"]["temp_max"])
temp =  to_celcius(json["main"]["temp"])
pressure = json["main"]["pressure"]
humidity = json["main"]["humidity"]
wind_speed = json["wind"]["speed"]
clouds = json["clouds"]["all"]
time = Time.new
time_min = if time.min < 10 then "0" + time.min.to_s else time.min end
time_month = if time.month < 10 then "0" + time.month.to_s else time.month end
current_time = "#{time.hour}:#{time_min} #{time.day}.#{time_month}.#{time.year}"

message_html = "<header><h1 style='text-align: center'>GrzeluBot v1.0</h1><main style='line-height: 1.5'>
     </header><h2 style='text-align: center'>Pogoda dla miasta #{name}</h2><br><img src=#{icon_src} width='50' height ='50'><p>Warunki pogodowe: #{translation(weather_description)}</p><p>Temperatura: #{temp} stopni Celsjusza(od #{min_temp} do #{max_temp})</p><p>Cisnienie: #{pressure}hpa</p><p>Predkość wiatru: #{wind_speed}mph</p><p>Wilgotność powietrza: #{humidity}%</p><p>Zachmurzenie: #{clouds}%</p> <footer style='text-align: center; box-sizing: border-box; padding-top: 32px;'>     Wiadomość wygenerowana przez GrzeluBot, Pozdrawiam</footer>"

class Mailer 
  
  def initialize(options)
    Pony.options = options
  end
  
  def mail_details(details, body)
    @to           = details[:to]
    @from         = details[:from]
    subject       = details[:subject]
    template_path = details[:template_path]
    
    Pony.mail(:to => @to, :from => @from, :subject => subject, :html_body => body)
  end
end

options = { :via => :smtp,
            :charset => "UTF-8",
            :via_options => {
              :address              => 'smtp.gmail.com',
              :port                 => '587',
              :enable_starttls_auto => true,
              :user_name            => 'grzelubot@gmail.com',
              :password             => 'password',
              :authentication       => :plain, 
              :domain               => "localhost.localdomain" }
          }

mailer = Mailer.new(options)

details = { to: 'grzeluud@gmail.com',
            from: 'grzelubot@gmail.com',
            subject: 'Pogoda ' + current_time }

mailer.mail_details(details, message_html)
