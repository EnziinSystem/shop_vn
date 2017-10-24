Devise.setup do |config|

  config.mailer_sender = 'SuperShop <admin@enziin.com>'

  require 'devise/orm/active_record'

  config.secret_key = '9c14551f28d0e75224b881c616002e4ece67f3b34355bff66f242efa2e19dc4d9a3703786beedcc890f5463657fcffce686f997dddf8d075e7c52e3af980a8a3'

  config.scoped_views = true

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10

  config.reconfirmable = false
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete

  config.timeout_in = 10.days

  config.lock_strategy = :failed_attempts
  config.unlock_keys = [:email]
  config.unlock_strategy = :both
  config.maximum_attempts = 5
  config.unlock_in = 10.minutes
  config.last_attempt_warning = true

  require 'omniauth-google-oauth2'
  config.omniauth :google_oauth2, ENV['GOOGLE_APP_ID'], ENV['GOOGLE_APP_SECRET'], {access_type: 'online', approval_prompt: '', skip_jwt: true}

  require 'omniauth-facebook'
  config.omniauth :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']

  require 'omniauth-twitter'
  config.omniauth :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET']

end
