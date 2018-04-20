# require 'redis'
require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/namespace'
require 'nokogiri'
require 'open-uri'
require 'yajl'
require 'parallel'
require 'webcache'

require 'pry'

require_relative 'lib/imdb'

require_relative 'controllers/api/v1/api_controller'

map('/api/v1/') { run APIController }
