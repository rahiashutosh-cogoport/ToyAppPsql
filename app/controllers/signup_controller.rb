require 'securerandom'
$redis = Redis::Namespace.new("my_app", :redis => Redis.new)

class SignupController < ApplicationController
  skip_before_action :verify_authenticity_token

  def signup
  end

  def commit_user
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  	hash_response = {}    
  	user = User.new(
  		:name => params[:user_name],
  		:email_id => params[:email_id],
  		:aadhar_num => params[:aadhar_num],
  		:contact_num => params[:contact_num],
  		:city => params[:city],
  		:country => params[:country],
  		:password => params[:password])
  	user.save
  	if user.errors.messages.length != 0  		
  		hash_response[:statusCode] = 400
  		hash_response[:errors] = user.errors.messages
  		render :json => hash_response.to_json
  	else
      verification_token_user = SecureRandom.alphanumeric
      $redis[user.aadhar_num] = verification_token_user
      puts "ASSIGNING TOKEN" + verification_token_user.to_s + " TO AADHAR " + user.aadhar_num.to_s   
      UserMailer.welcome_email(user, verification_token_user).deliver_now
  		hash_response[:statusCode] = 200
  	  # render :json => hash_response.to_json
  		# redirect_to '/login'
      redirect_to 'http://localhost:3001/index'
  	end
  end

  def verify_email
    otp = params[:otp]
    aadhar = params[:aadhar_num]
    token = $redis[aadhar]
    if otp == token      
      user = User.where(:aadhar_num => aadhar)[0]
      user.verified = true
      user.save
      render 'email_verification_successful'
    else
      render :json => {
        :message => "Wrong OTP"
      }
    end
  end
end
