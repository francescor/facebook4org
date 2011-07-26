# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_changingroom_matchingapp_session',
  :secret      => 'a7070abaae9e884c5ee6f2c05aa34b214c6082f7479f503672f2b215bc487d2101671be9bdc75ed264d32f3d104d217f09af42b30242c0da08e53c876fb30236'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
