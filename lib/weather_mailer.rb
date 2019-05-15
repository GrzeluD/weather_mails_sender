require 'bundler/setup'

require 'json'
require 'erb'
require 'faraday'
require 'pony'
require 'awesome_print'

require 'weather_mailer/json_client'
require 'weather_mailer/weather_features'
require 'weather_mailer/open_weather_map'
require 'weather_mailer/mailer'
require 'weather_mailer/weather_mailer_app'