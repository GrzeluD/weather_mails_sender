<h1>Weather mail sender</h1>

<p>This is a simple program made in ruby language, that connects to the OpenWeatherMap API's and send a mail with current weather.</p> 

<h2>Gems used to create a program:</h2>
<ul>
  <li><a href="https://rubygems.org/gems/json/versions/1.8.3">json</a> - Build in gem, JSON pareser.</li>
  <li><a href="https://ruby-doc.org/stdlib-2.6.3/libdoc/erb/rdoc/ERB.html">erb</a> - Build in gem for HTML mail templat.</li>
  <li><a href="https://rubygems.org/gems/faraday/versions/0.9.2">faraday</a> - Gem for collecting data from API.</li>
  <li><a href="https://rubygems.org/gems/pony/versions/1.11">pony</a> - Gem for sending e-mails in easy way.</li>
  <li><a href="https://rubygems.org/gems/awesome_print/versions/1.8.0">awesome_print</a> - Gem for printing Ruby objects to visualize thier structure.</li> 
</ul>

<h2>Classes:</h2>
<ul>
  <li>JSONClient - Connecting to the API using faraday, sets url authentication key, then return searching informations in parsed json.</li>
  <li>OpenWeatherMap - Here is where i set URL and authentication key and use JSONClient to get my parsed json and specify city that i looking for in the parameter.</li>
  <li>Mailer - Sets options for pony gem.</li>
  <li>WeatherFeatures - Basically this is Class where i build global variables so i can use them in my erb template, set options and details for Mailer class like mail account (this is gmail example, for other ways check <a href="https://github.com/benprew/pony">documentation</a>), password or who gonna receive mail, also made method for changing  temperature from fahrenheit or kelvin to celsius and method for translating weather conditions.</li>
  <li>WeatherMailerApp - Getting everythink together and run program.</li>
</ul>

<br>
<h3>Output of my program: </h3>
<img src="https://github.com/GrzeluD/weather_mails_sender/blob/master/output.png">
<p>Program gets from the API icon, name of city looking in phrase, weather conditions, temperature in celcius, pressure, speed of wind, humidity and cloudity.</p>

<h2>Getting started</h2>
<p>If u like to use this program to send to someone e-mail with a current weather here is how to do it:</p>
<p>Program is made to use in local for now, so download ZIP.</p>
<p>If you have ruby installed, go to directory and install gems from bundler.</p>
<p>Go to lib/weather_mailer/weather_features.rb and set in options obiect :user_name as your mail account and :password for this account, also in details to: for whos gonna receive mail, from: as your account name, subject: and template_path: to your HTML mail template</p>

```ruby
  $options = { :via => :smtp,
            :charset => "UTF-8",
            :via_options => {
              :address              => 'smtp.gmail.com',
              :port                 => '587',
              :enable_starttls_auto => true,
              :user_name            => your_accout_name,
              :password             => you_account_password,
              :authentication       => :plain, 
              :domain               => "localhost.localdomain" }
          }

    $details = { to: recipient_account_name,
            from: your_account_name,
            subject: your_email_subject, 
            template_path: path_to_your_template}
```
            
<p>Then go to bin/ on your terminal and type ./weather_mailer "name_of_city_you_looking_for"(this works only for Linux and Mac users)</p>
