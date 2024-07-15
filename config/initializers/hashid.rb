Hashid::Rails.configure do |config|
  salt = Rails.application.credentials.dig(:hashid, :salt)

  # If salt is not found in credentials, use a dummy salt
  # This allows the application to build and run in environments where
  # credentials are not available (e.g., during Docker build process)
  salt ||= SecureRandom.hex

  config.salt = salt
  config.min_hash_length = 8
end
