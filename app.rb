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
  session[:message] = ''
  @meetups = Meetup.all
  erb :'meetups/index'
end

get '/meetups/:id' do
  @message = session[:message]
  if params[:join] == '1'
    if session[:user_id].nil?
      @message = "You must sign in first"
    else
      @id = params[:id]
      @membership = Membership.new(meetup_id: params[:id], user_id: session[:user_id])

      if Membership.all.find_by(meetup_id: params[:id], user_id: session[:user_id]).nil?
        @membership.save
        @message = "You joined the meetup"
      else @message = "You are already a member"
      end
    end
  end

  @meetup = Meetup.where(id: params[:id]).first
  @creator = @meetup.creator

  if Membership.where(meetup_id: params[:id]) != []
    @members = @meetup.users
  end
  erb :'meetups/show'
end

get '/new' do
  @messages = {name: '', location: '', description: ''}
  erb :'meetups/new'
end

post '/new' do
  if session[:user_id].nil?
    @messages = {sign_in: 'You must sign in'}
    @name = params['name']
    @location = params['location']
    @description = params['description']
  else
    @meetup = Meetup.new(name: params[:name], location: params[:location], description: params[:description], created_at: Time.now, updated_at: Time.now, creator_id: session[:user_id])

    if @meetup.valid?
      @meetup.save
      @id = @meetup.id
      session[:message] = "Meetup created!"
      redirect "/meetups/#{@id}"
    else @messages = @meetup.errors.messages
      @name = params['name']
      @location = params['location']
      @description = params['description']
    end
  end
  erb :'meetups/new'
end
