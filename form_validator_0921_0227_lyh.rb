# 代码生成时间: 2025-09-21 02:27:59
# FormValidator is a Sinatra app that handles form data validation.
class FormValidator < Sinatra::Base

  # Route to handle POST requests with form data.
  post '/validate' do
    # Parse the JSON payload.
    data = JSON.parse(request.body.read)

    # Initialize an array to store error messages.
    errors = []

    # Validate 'name' field.
    if data['name'].nil? || data['name'].empty?
      errors << 'Name cannot be empty.'
    end

    # Validate 'email' field.
    if data['email'].nil? || data['email'].empty?
      errors << 'Email cannot be empty.'
    elsif !data['email'].match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
      errors << 'Email is invalid.'
    end

    # Validate 'password' field.
    if data['password'].nil? || data['password'].empty?
      errors << 'Password cannot be empty.'
    elsif data['password'].length < 8
      errors << 'Password must be at least 8 characters long.'
    end

    # Return an error message if there are any validation errors.
    if errors.any?
      content_type :json
      { status: 'error', messages: errors }.to_json
    else
      # If everything is valid, return a success message.
      content_type :json
      { status: 'success', message: 'Form data is valid.' }.to_json
    end
  end

end
