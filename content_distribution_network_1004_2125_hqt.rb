# 代码生成时间: 2025-10-04 21:25:31
# 简单的内容分发网络程序
class ContentDistributionNetwork < Sinatra::Base
  # 设置缓存文件夹
  set :cache_folder, 'cache'
  
  # 启动时创建缓存文件夹
  before do
    FileUtils.mkdir_p(settings.cache_folder)
  end

  # 根路由，列出缓存文件
  get '/' do
    "<html><body><ul>#{Dir.entries(settings.cache_folder).map { |f| "<li>#{f}</li>" }.join}</ul></body></html>"
  end

  # 缓存内容的GET请求
  get '/cache/:filename' do
    filename = params[:filename]
    cache_path = File.join(settings.cache_folder, filename)

    # 检查文件是否存在
    if File.exist?(cache_path)
      content_type 'text/plain'
      status 200
      File.read(cache_path)
    else
      status 404
      'File not found'
    end
  end

  # 缓存内容的POST请求
  post '/cache/:filename' do
    filename = params[:filename]
    cache_path = File.join(settings.cache_folder, filename)
    content = request.body.read

    # 检查是否已缓存
    unless File.exist?(cache_path)
      File.open(cache_path, 'w') { |f| f.write(content) }
      status 201
      'Cached content'
    else
      status 409
      'Content already cached'
    end
  end

  # 错误处理
  not_found do
    content_type 'text/plain'
    '404 Not Found'
  end

  error do
    'An error occurred'
  end
end
