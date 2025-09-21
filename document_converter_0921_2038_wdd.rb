# 代码生成时间: 2025-09-21 20:38:00
# DocumentConverter is a Sinatra application that converts documents.
# It uses the Roo gem to handle different document formats.
class DocumentConverter < Sinatra::Application
  # Set the route for converting documents.
  get '/convert' do
    # Check if a file is provided.
    if params[:file].nil?
      @error = 'No file provided for conversion.'
      erb :error
    else
      # Save the uploaded file temporarily.
      tempfile = params[:file][:tempfile]
      filename = params[:file][:filename]
      
      # Determine the document type.
      begin
        document = Roo::Spreadsheet.open(tempfile, file_warning: :ignore)
        # Convert the document to a new format (e.g., JSON).
        converted_content = convert_to_json(document)
        # Set the content type and return the converted document.
        content_type 'application/json'
        converted_content.to_json
      rescue => e
        # Handle any errors that occur during conversion.
        @error = "Error converting file: #{e.message}"
        erb :error
      ensure
        # Ensure the temporary file is deleted after conversion.
        FileUtils.rm_f(tempfile) if File.exist?(tempfile)
      end
    end
  end

  # Helper method to convert a Roo document to JSON.
  def convert_to_json(document)
    # Initialize an array to hold the converted rows.
    rows = []
    # Iterate over each row in the document.
    document.each_row_streaming do |row|
      # Convert each row to a hash and add it to the rows array.
      rows << row.to_h
    end
    # Return the rows as a JSON object.
    JSON.generate(rows)
  end

  # Error page displaying the error message.
  get '/error' do
    erb :error
  end
end

# Error view template in Embedded Ruport Markup (ERB) format.
__END__

-- error.erb
<!DOCTYPE html>
<html>
<head>
  <title>Document Conversion Error</title>
</head>
<body>
  <h1>Document Conversion Error</h1>
  <p><%= @error %></p>
</body>
</html>
