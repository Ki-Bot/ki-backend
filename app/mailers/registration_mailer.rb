class RegistrationMailer < ApplicationMailer
  # layout 'mailer'

  def welcome(user)
    @user = user
    @link = ENV['welcome_email_link']
    mail(to: @user.email, subject: 'Welcome to KI')
  end

  def welcome_email(user)
    @user = user
    @name = @user.name
    @code = @user.auth_token
    mail(to: @user.email, subject: 'Welcome to KI! Verify your email address.')
  end
end
