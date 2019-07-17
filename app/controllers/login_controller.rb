require 'securerandom'
$redis = Redis::Namespace.new("my_app", :redis => Redis.new)

class LoginController < ApplicationController
  skip_before_action :verify_authenticity_token
  def login
    headers['Access-Control-Allow-Origin'] = 'http://localhost:3001'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers['Access-Control-Allow-Credentials'] = 'true'
  	if request.post?
  		if cookies[:user_token].present? #Session will be maintained
  			aadhar = $redis[cookies[:user_token]]
        puts 'TOKEN: ' + cookies[:user_token]
        puts 'AADHAR AS IN REDIS: ' + aadhar.to_s 
        if aadhar.present?
          puts "AADHAR: " + aadhar.to_s
          user = User.where(:aadhar_num => aadhar)[0]
          
          #ActionMailer::Base.mail(template_path: 'user_mailer', template_name: 'welcome_email', from: "ashutoshrahi1997@gmail.com", to: "rakshitsharma.nitsri@gmail.com", subject: "Registration for Rates Search Dashboard successful").deliver!            
          #redirect_to '/rates', user_logged_in: user.name
          render :json => {
            :logged_in => true,
            :logged_in_name => user.name,
            :token => cookies[:user_token]
          }.to_json
        else
          #render 'session_ended'
          render :json => {
            :logged_in => false,
            :message => "Session Expired"
          }.to_json
        end	  		
  		else #Prompt Login        
  			user = User.where(:email_id => params[:email_id])[0]        
  			if user.present?          
  				if user.password == params[:password]        
  					token_user = SecureRandom.alphanumeric
            puts 'ASSIGNED TOKEN: ' +   token_user.to_s
  					cookies.permanent[:user_token] = token_user
  					$redis[token_user] =  user.aadhar_num
            #$redis.set(token_user, user.aadhar_num, ex: 10)
  					#redirect_to '/rates', user_logged_in: user.name
            render :json => {
              :logged_in => true,
              :logged_in_name => user.name
            }.to_json
  				else
  					#render 'invalid_password'
            render :json => {
              :logged_in => false,
              :message => "Invalid Password"
            }.to_json
  				end
  			else
  				#render 'unregistered_user'
          render :json => {
              :logged_in => false,
              :message => "Unregistered User"
            }.to_json
  			end
  		end
  	else
  		render 'login'
  	end
  end

  def logout
  	token = cookies[:user_token]
  	cookies.delete :user_token
  	$redis.del(token)
  	#render 'login'
    render :json => {
      :logged_in => false,
      :message => "Logged out successfully"
    }
  end

  def logged_in
  	user_token = cookies[:user_token]
  	if $redis[user_token].present?
  		render :json => { 
         :status => :ok, 
         :message => "User Logged In"
      	}.to_json
    else
    	render :json => { 
         :status => :ok, 
         :message => "Not Logged In"
        }.to_json
  	end
  end

  def current_user
    headers['Access-Control-Allow-Origin'] = 'http://localhost:3001'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers['Access-Control-Allow-Credentials'] = 'true'
  	user_token = cookies[:user_token]
  	if user_token.present?
  		aadhar = $redis[user_token]
  		if aadhar.present?
  			user = User.where(:aadhar_num => aadhar)[0]
		  	render :json => {
		  		:status => :ok,
		  		:user => user,
		  		:message => 'Logged In'
		  	}.to_json
  		else
  			render :json => {
		  		:status => :ok,
          :user => nil,	  		
		  		:message => 'Not Logged In'
		  	}.to_json
  		end
  	else
  		render :json => {
	  		:status => :ok,
        :user => nil,
	  		:message => 'Not Logged In'
	  	}.to_json
  	end  	
  end  
end
