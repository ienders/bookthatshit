Rails.application.config.middleware.use OmniAuth::Builder do
  puts ENV["GOOGLE_KEY"]
  puts ENV["GOOGLE_SECRET"]
  provider :google_oauth2, ENV["GOOGLE_KEY"], ENV["GOOGLE_SECRET"]
end