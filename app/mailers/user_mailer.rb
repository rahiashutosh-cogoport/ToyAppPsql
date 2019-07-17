class UserMailer < ActionMailer::Base
  #include Sidekiq::Mailer
  default from: 'ashutoshrahi1997@gmail.com'
 
  def welcome_email(user, token)
  	@user = user
  	@token = token
    @url  = 'http://example.com/login'
    @verify_link = "http://localhost:3000/verify_email?otp=" + token.to_s + '&aadhar_num=' + @user.aadhar_num.to_s 
    mail(from: 'ashutoshrahi1997@gmail.com', to: @user.email_id, subject: 'Welcome to Rates Search API!')
  end
end
