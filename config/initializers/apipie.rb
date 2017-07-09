Apipie.configure do |config|
  config.app_name = "KI Api"
  config.api_base_url = "/api"
  config.doc_base_url = "/api/docs"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"

  config.validate = false
  config.app_info = 'KI project API endpoints'
end
