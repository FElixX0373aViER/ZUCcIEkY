# 代码生成时间: 2025-10-05 01:48:28
# 定义一个简单的系统备份恢复工具
class BackupRestoreTool < Sinatra::Base

  # 定义备份文件的存储路径
  BACKUP_DIR = 'backups/'

  # GET请求，列出所有备份文件
  get '/' do
    # 检查备份目录是否存在，如果不存在则创建
    FileUtils.mkdir_p(BACKUP_DIR)
    # 获取备份目录中的所有文件
    backups = Dir.glob("#{BACKUP_DIR}*")
    # 将文件名列表返回给客户端
    { backups: backups }.to_json
  end

  # POST请求，创建一个新的备份
  post '/backup' do
    # 获取当前时间作为备份文件名
    time_stamp = Time.now.strftime("%Y%m%d%H%M%S")
    backup_file = "#{BACKUP_DIR}backup_#{time_stamp}.tar.gz"
    begin
      # 调用系统命令创建备份
      `tar -czf #{backup_file} .`
      # 响应成功信息
      { status: 'Backup created successfully', file: backup_file }.to_json
    rescue => e
      # 错误处理，返回错误信息
      { status: 'Error creating backup', error: e.message }.to_json
    end
  end

  # POST请求，恢复指定的备份文件
  post '/restore' do
    # 从请求体中获取要恢复的备份文件名
    params = JSON.parse(request.body.read)
    backup_file = params['backup_file']
    begin
      # 检查备份文件是否存在
      unless File.exist?(backup_file)
        return { status: 'Error', error: 'Backup file not found' }.to_json
      end
      # 调用系统命令恢复备份
      `tar -xzf #{backup_file} -C .`
      # 响应成功信息
      { status: 'Restore completed successfully' }.to_json
    rescue => e
      # 错误处理，返回错误信息
      { status: 'Error restoring backup', error: e.message }.to_json
    end
  end
end
