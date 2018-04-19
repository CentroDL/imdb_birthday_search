# require 'redis'
require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'httparty'
require 'uri'
require 'yajl'

require_relative 'server'

# run IvyImdbAPI::Server