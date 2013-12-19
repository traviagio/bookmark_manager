require 'sinatra'
require 'sinatra/partial'
require 'data_mapper'
require './lib/link'
require './lib/tag' 
require './lib/user'
require 'rack-flash'

require_relative 'data_mapper_setup'

require_relative 'helpers/application'

require_relative 'controllers/application'
require_relative 'controllers/links'
require_relative 'controllers/sessions'
require_relative 'controllers/tags'
require_relative 'controllers/users'




use Rack::Flash
enable :sessions
set :session_secret, 'super secret'
set :partial_template_engine, :erb

  








