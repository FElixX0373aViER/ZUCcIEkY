# 代码生成时间: 2025-09-19 18:39:52
# ExcelGenerator is a Sinatra application that generates Excel spreadsheets based on user input.
class ExcelGenerator < Sinatra::Application

  # GET '/' - Home page with a form to upload Excel file and generate a new one.
  get '/' do
    erb :index
  end

  # POST '/generate' - Endpoint to handle the uploaded Excel file and generate a new one.
  post '/generate' do
    begin
      # Get the uploaded file from the params
      excel_file = params[:excel_file][:tempfile]

      # Create a new Excel spreadsheet using Roo
      excel = Roo::Spreadsheet.open(excel_file)
      new_excel = Roo::Spreadsheet.new('new_spreadsheet.xls')

      # Copy data from the uploaded file to the new file
      new_excel.add_worksheet('Generated')
      excel.sheets.each do |sheet|
        data = excel.sheet(sheet)
        new_excel.sheet('Generated').add_rows(data.parse(false))
      end

      # Save the new Excel file
      new_excel.write('generated_spreadsheet.xls')
      new_excel.close

      # Return the generated Excel file to the user
      send_file 'generated_spreadsheet.xls', filename: 'generated_spreadsheet.xls', type: 'application/vnd.ms-excel'
    rescue => e
      # Handle any errors and return a 500 error with an error message
      status 500
      "Error: #{e.message}"
    end
  end
end

# Configuration for the Sinatra application
configure do
  # Set the public folder for static files
  set :public_folder, 'public'
  # Set the views folder for ERB templates
  set :views, 'views'
end

# Error handling for 404 errors
error do
  erb :'404', locals: { error: env['sinatra.error'] }
end

# Error handling for 500 errors
error do
  erb :'500', locals: { error: env['sinatra.error'] }
end