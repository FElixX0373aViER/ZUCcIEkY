# 代码生成时间: 2025-10-01 02:56:21
# Password Encryption Service using Ruby and Sinatra
require 'sinatra'
require 'digest'

# This service provides basic password encryption and decryption functionality.
# It uses the Digest library for hashing passwords.

# Initialize the app
class PasswordEncryptionService < Sinatra::Base

  # Define the route for the encryption endpoint
  get '/encrypt' do
    # Retrieve the raw password from the query parameters
    raw_password = params['password']
    unless raw_password
      return json_error("Missing password parameter.")
    end

    # Encrypt the password using SHA-256
    encrypted_password = Digest::SHA256.hexdigest(raw_password)

    # Return the encrypted password as a JSON response
    json_response({ encrypted: encrypted_password })
  end

  # Define the route for the decryption endpoint
  get '/decrypt' do
    # Retrieve the encrypted password from the query parameters
    encrypted_password = params['password']
    unless encrypted_password
      return json_error("Missing password parameter.")
    end

    # Since decryption is not possible with SHA-256 (one-way hash),
    # return an error message indicating so.
    json_error("Decryption is not possible with SHA-256.")
  end

  # Helper method to return a JSON error response
  def json_error(message)
    content_type :json
    { error: message }.to_json
  end

  # Helper method to return a JSON response
  def json_response(data)
    content_type :json
    data.to_json
  end

end

# Run the app if it's the main process
if __FILE__ == $0
  PasswordEncryptionService.run! :host => '0.0.0.0', :port => 4567
end
"}