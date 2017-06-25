class RegistrationMailer < ApplicationMailer
  # layout 'mailer'

  def welcome(user)
    @user = user
    @link = ENV['welcome_email_link']
    mail(to: @user.email, subject: 'Welcome to KI')
  end
end
