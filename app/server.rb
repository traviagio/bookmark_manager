
require 'sinatra'
require 'data_mapper'
require './lib/link'
require './lib/tag' 
require './lib/user'
require 'rack-flash'
require_relative 'data_mapper_setup'

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
    flash.now[:errors] = @user.errors.full_messages
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

get '/sessions/new' do
  erb :"sessions/new"
end

post '/sessions' do
  email, password = params[:email], params[:password]
  user = User.authenticate(email, password)
  if user
    session[:user_id] = user.id
    redirect to('/')
  else
    flash[:errors] = ["The email or password are incorrect"]
    erb :"sessions/new"
  end
end

delete '/sessions' do
    session[:user_id] = nil
    flash[:notice] = "Good bye!"
    redirect to('/')
end
  

helpers do

  def current_user    
    @current_user ||=User.get(session[:user_id]) if session[:user_id]
  end

end




