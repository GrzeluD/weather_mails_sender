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
  <li>WeatherFeatures - Basically this is Class where i build global variables so i can use them in my erb template, set options and details for Mailer class like mail account, password or who gonna receive mail, also made method for changing  temperature from fahrenheit or kelvin to celsius and method for translating weather conditions.</li>
  <li>WeatherMailerApp - Getting everythink together and run program.</li>
</ul>

<br>
<h3>Output of my program: </h3>
<img src="https://github.com/GrzeluD/weather_mails_sender/blob/master/output.png">
<p>Program gets from the API icon, name of city looking in phrase, weather conditions, temperature in celcius, pressure, speed of wind, humidity and cloudity.</p>
