# 代码生成时间: 2025-09-18 09:36:08
# Sinatra应用：配置文件管理器
require 'sinatra'
require 'json'
# TODO: 优化性能

# 配置文件目录
CONFIG_DIR = './configs'

# 设置配置文件目录
set :config_dir, CONFIG_DIR

# 错误处理
# 扩展功能模块
error do
  e = request.env['sinatra.error']
  status 500
  { error: e.message }.to_json
end

# 获取所有配置文件
get '/config' do
  # 检查目录存在
  unless Dir.exist?(settings.config_dir)
    status 404
    { error: '配置文件目录不存在' }.to_json
    return
  end

  # 获取所有配置文件列表
  Dir.glob(File.join(settings.config_dir, '*')).map { |file| File.basename(file) }.to_json
end

# 获取单个配置文件内容
get '/config/:filename' do
  # 检查文件存在
  unless File.exist?(File.join(settings.config_dir, params[:filename]))
    status 404
    { error: '配置文件不存在' }.to_json
    return
  end

  # 读取配置文件内容
  content = File.read(File.join(settings.config_dir, params[:filename]))
  { content: content }.to_json
end

# 更新配置文件内容
put '/config/:filename' do
# 添加错误处理
  # 检查文件存在
  unless File.exist?(File.join(settings.config_dir, params[:filename]))
    status 404
    { error: '配置文件不存在' }.to_json
    return
  end

  # 读取更新内容
  content = request.body.read

  # 更新配置文件
# NOTE: 重要实现细节
  File.open(File.join(settings.config_dir, params[:filename]), 'w') do |file|
    file.write(content)
  end

  { message: '配置文件更新成功' }.to_json
end

# 删除配置文件
delete '/config/:filename' do
  # 检查文件存在
  unless File.exist?(File.join(settings.config_dir, params[:filename]))
    status 404
    { error: '配置文件不存在' }.to_json
# 扩展功能模块
    return
  end

  # 删除配置文件
  File.delete(File.join(settings.config_dir, params[:filename]))
  { message: '配置文件删除成功' }.to_json
# 改进用户体验
end

# 创建配置文件
post '/config' do
# NOTE: 重要实现细节
  # 读取创建内容
  content = request.body.read

  # 生成新的配置文件名
  filename = params[:filename] || 'config'
  filename += '.json' unless filename.end_with?('.json')

  # 创建配置文件
  File.open(File.join(settings.config_dir, filename), 'w') do |file|
    file.write(content)
  end

  { message: '配置文件创建成功' }.to_json
end

# 错误处理，捕捉其他错误
error do
  e = request.env['sinatra.error']
  status 500
  { error: e.message }.to_json
end
?>