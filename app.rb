require 'sinatra'
require_relative 'config/application'
require 'pry'
enable :sessions

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.all
  erb :'meetups/index'
end

get '/meetups/:id' do
  @meetup = Meetup.where(id: params[:id])
  @creator = User.where(id: @meetup.first.creator_id)
  # binding.pry
  if Membership.where(meetup_id: params[:id]) != []
    @members = User.where(id: Membership.where(meetup_id: params[:id]).first.user_id)
  end
  @message = session[:message]
  erb :'meetups/show'
end

get '/new' do
  erb :'meetups/new'
end

post '/new' do
  # binding.pry
  @id = Meetup.create(name: params[:name], location: params[:location], description: params[:description], created_at: Time.now, updated_at: Time.now, creator_id: session[:user_id]).id

  session[:message] = "Meetup created!"

  redirect "/meetups/#{@id}"

end
