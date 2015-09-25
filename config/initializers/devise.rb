Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate
  # random tokens. Changing this key will render invalid all existing
  # confirmation, reset password and unlock tokens in the database.
  # Devise will use the `secret_key_base` on Rails 4+ applications as its `secret_key`
  # by default. You can change it below and use your own secret key.
  # config.secret_key = '204d107057c676f938eedce8a1c65d13fc614f3b862d65f222f59a9230b74f5be7d08724233db3b82f04adea3c7525ac8ac8819b31a19368b7da5c8fb227dea8'

  config.mailer_sender = 'no-reply@example.com'

  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10

  # Setup a pepper to generate the encrypted password.
  # config.pepper = '7c1ff596298d0aba89df25cb537ddd3752f5e488b977000ce4f9116c7c3bca6c031d4aa61d56fe3f6becc1fc10f137b32039ec509e0c800092fdc47c78059a18'

  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..72
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
end
