# require 'redis'
require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/namespace'
require 'httparty'
require 'uri'
require 'yajl'

require_relative 'app'
require_relative 'controllers/api/v1/api_controller'

map('/api/v1/') { run APIController }