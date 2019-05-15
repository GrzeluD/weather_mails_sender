class WeatherMailerApp
  def initialize(phrase)
    @phrase = phrase
  end
  
  def run
    bot = OpenWeatherMap.new
    weather = bot.search @phrase
    WeatherFeatures.new(weather).build
    mailer = Mailer.new($options)
    mailer.mail_details($details)
  end
end