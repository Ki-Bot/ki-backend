OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['twitter_app_id'], ENV['twitter_secret']
  provider :facebook, '446323952418743', 'ab28b4928aa85f6b9c90d37ccc65d663'
  #provider :facebook, ENV['facebook_app_id'], ENV['facebook_secret']#, :callback_path => "/api/auth/facebook/callback", callback_url: "http://localhost:3000/api/auth/facebook/callback"
end