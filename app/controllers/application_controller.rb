require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

	configure do
		set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
	end

	get "/" do
		erb :index
	end

	get "/signup" do
		erb :signup
	end
	get "/login" do
		erb :login
	end


	helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end
	end

	get "/success" do
		
		if logged_in?
		
			erb :success
		else
			puts logged_in?
			binding.pry
			redirect "/login"
		end
	end

	get "/failure" do
		erb :failure
	end

	get "/logout" do
		session.clear
		redirect to ("/")
	end


	post "/signup" do
		user = User.new(:username => params[:username], :password => params[:password])
		if user.save
		  redirect to ("/login")
		else
		  redirect to ("/failure")
		end
	  end

	post "/login" do
		user = User.find_by(:username => params[:username])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect to ("/success")
		else
			redirect to ("/failure")
		end
	end


end
