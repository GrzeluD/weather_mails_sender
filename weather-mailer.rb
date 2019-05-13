require "faraday"
require "awesome_print"
require "json"
require "pony"
require "erb"

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

class OpenWeatherMap
  def initialize
    @json_client = JSONClient.new('https://api.openweathermap.org')
    @json_client.authenticate("cbe7de6d147912e998501c064c7d1dc4")
  end
  
  def search(phrase)
    json = @json_client.get '/data/2.5/weather?q=', phrase
  end
end

class WeatherFeatures
  attr_accessor :data
  def initialize(data) 
    @data = data
  end
  
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
    when "overcast clouds"
      "Zachmurzenie"
    when "light rain"
      "Lekki deszcz"
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
  
  def set_globals
    $name = @data["name"]
    $weather_description = translation(@data["weather"].first["description"])
    $icon = @data["weather"].first["icon"]
    $icon_src = "http://openweathermap.org/img/w/" + $icon + ".png"
    $min_temp = to_celcius(@data["main"]["temp_min"])
    $max_temp = to_celcius(@data["main"]["temp_max"])
    $temp =  to_celcius(@data["main"]["temp"])
    $pressure = @data["main"]["pressure"]
    $humidity = @data["main"]["humidity"]
    $wind_speed = @data["wind"]["speed"]
    $clouds = @data["clouds"]["all"]
    time = Time.new
    $time_min = if time.min < 10 then "0" + time.min.to_s else time.min end
    $time_month = if time.month < 10 then "0" + time.month.to_s else time.month end
    $current_time = "#{time.hour}:#{$time_min} #{time.day}.#{$time_month}.#{time.year}"
    $options = { :via => :smtp,
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

    $details = { to: 'grzeluud@gmail.com',
            from: 'grzelubot@gmail.com',
            subject: 'Pogoda ' + $current_time, 
            template_path: 'mail_template.html.erb'}
  end
end

class Mailer 
  
  def initialize(options)
    Pony.options = options
  end
  
  def mail_details(details)
    @to           = details[:to]
    @from         = details[:from]
    subject       = details[:subject]
    template_path = details[:template_path]
    
    context = binding
    body = ERB.new(File.read(template_path)).result(context)
    Pony.mail(:to => @to, :from => @from, :subject => subject, :html_body => body)
  end
end



class WeatherMailerApp
  def initialize(phrase)
    @phrase = phrase
  end
  
  def run
    bot = OpenWeatherMap.new
    weather = bot.search @phrase
    WeatherFeatures.new(weather).set_globals
    mailer = Mailer.new($options)
    mailer.mail_details($details)
  end
end

WeatherMailerApp.new("krzeszowice").run