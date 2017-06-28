OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['twitter_app_id'], ENV['twitter_secret']
  provider :facebook, ENV['facebook_app_id'], ENV['facebook_secret']#, :callback_path => "/api/auth/facebook/callback", callback_url: "http://localhost:3000/api/auth/facebook/callback"
end