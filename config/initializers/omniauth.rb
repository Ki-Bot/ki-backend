OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'BiORaN1jKqOnGG1aLjXiaFqjS', '6h9UkdrMKwI9Dbza1zMOPLDOKzoKsY0SkExJq3gBlcQrMyub15'
  provider :facebook, '446323952418743', 'ab28b4928aa85f6b9c90d37ccc65d663'#, :callback_path => "/api/auth/facebook/callback", callback_url: "http://localhost:3000/api/auth/facebook/callback"
end