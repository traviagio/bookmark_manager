
require 'sinatra'
require 'data_mapper'
require './lib/link'
require './lib/tag' 
require './lib/user'
require 'rack-flash'

env = ENV["RACK_ENV"] || "development"
# we're telling datamapper to use a postgres database on localhost. The name will be "bookmark_manager_test" or "bookmark_manager_development" depending on the environment
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
DataMapper.finalize
DataMapper.auto_upgrade!



use Rack::Flash

enable :sessions
set :session_secret, 'super secret'

get '/' do
  @links = Link.all
  erb :index
end

get '/users/new' do
	@user = User.new
 	erb :"/users/new"
end


post '/users' do
  @user = User.create(:email => params[:email], 
              :password => params[:password],
              :password_confirmation => params[:password_confirmation])  
  if @user.save
  	session[:user_id] = @user.id
  	redirect to('/')
  	else
  		flash[:notice] = "Sorry, your passwords don't match" 
  	erb :"users/new"
  end	
end

post '/links' do
  url = params["url"]
  title = params["title"]
  tags = params["tags"].split(" ").map{|tag| Tag.first_or_create(:text => tag)}
  Link.create(:url => url, :title => title, :tags => tags)
  redirect to('/')
end

get '/tags/:text' do
  tag = Tag.first(:text => params[:text])
  @links = tag ? tag.links : []
  erb :index
end

helpers do

  def current_user    
    @current_user ||=User.get(session[:user_id]) if session[:user_id]
  end

end

