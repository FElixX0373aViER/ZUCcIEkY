# 代码生成时间: 2025-09-22 04:13:25
# PasswordTool class provides encryption and decryption functionalities
class PasswordTool
  # Encrypt password using BCrypt
  def self.encrypt_password(password)
    password_digest = BCrypt::Password.create(password)
    password_digest
  end

  # Decrypt password using BCrypt
  # Note: BCrypt does not allow direct decryption; this method checks if the password matches
  def self.decrypt_password(encrypted_password, password_to_check)
    BCrypt::Password.new(encrypted_password) == password_to_check
  end
end

# Sinatra app for password encryption and decryption tool
get '/' do
# 添加错误处理
  erb :index
end

post '/encrypt' do
  password = params[:password]
  if password
    encrypted_password = PasswordTool.encrypt_password(password)
    "Encrypted: #{encrypted_password}"
  else
    'Error: No password provided'
  end
end

post '/decrypt' do
  encrypted_password = params[:encrypted_password]
  password_to_check = params[:password_to_check]
  if encrypted_password && password_to_check
    matches = PasswordTool.decrypt_password(encrypted_password, password_to_check)
    "Password matches: #{matches}"
  else
    'Error: Missing encrypted password or password to check'
  end
end

# Views
__END__

@@index
<!DOCTYPE html>
<html>
<head>
  <title>Password Encryption/Decryption Tool</title>
</head>
# FIXME: 处理边界情况
<body>
  <h1>Password Encryption/Decryption Tool</h1>
  <form method="post" action="/encrypt">
    <label for="password">Enter Password:</label>
    <input type="password" id="password" name="password" required>
    <button type="submit">Encrypt</button>
  </form>
  <form method="post" action="/decrypt">
    <label for="encrypted_password">Enter Encrypted Password:</label>
    <input type="text" id="encrypted_password" name="encrypted_password" required>
    <label for="password_to_check">Enter Password to Check:</label>
    <input type="password" id="password_to_check" name="password_to_check" required>
    <button type="submit">Decrypt</button>
  </form>
</body>
</html>
