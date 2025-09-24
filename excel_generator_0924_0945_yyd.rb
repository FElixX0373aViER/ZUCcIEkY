# 代码生成时间: 2025-09-24 09:45:14
# Excel表格自动生成器
class ExcelGenerator < Sinatra::Application

  # 设置允许跨域访问
  configure do
    set :allow_origin, '*'
  end

  # POST请求，接收JSON格式的数据并生成Excel文件
  post '/generate' do
    content_type :json

    # 尝试解析请求体中的JSON数据
    begin
      data = JSON.parse(request.body.read)
    rescue JSON::ParserError
      { error: 'Invalid JSON format' }.to_json
    end

    # 检查数据是否包含必要的属性
    unless data.is_a?(Hash) && data.key?(:rows) && data.key?(:columns)
      return { error: 'Missing required data' }.to_json
    end

    # 创建Excel工作簿
    @workbook = Roo::Spreadsheet.new('generated_file.xlsx')
    @workbook.default_sheet = @workbook.sheets.first

    # 填充列标题
    data[:columns].each_with_index do |column, index|
      @workbook.cell(0, index + 1, column)
    end

    # 填充行数据
    data[:rows].each_with_index do |row, index|
      row.each_with_index do |cell, cell_index|
        @workbook.cell(index + 1, cell_index + 1, cell)
      end
    end

    # 保存Excel文件
    @workbook.save

    # 返回成功信息和文件路径
    { success: true, file_path: 'generated_file.xlsx' }.to_json
  end

  # GET请求，下载生成的Excel文件
  get '/download' do
    content_type :excel
    send_file 'generated_file.xlsx'
  end

  # 错误处理，返回错误信息
  error do
    e = request.env['sinatra.error']
    { error: e.message }.to_json
  end
end
