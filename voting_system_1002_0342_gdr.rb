# 代码生成时间: 2025-10-02 03:42:22
# 配置Redis连接
redis = Redis.new

# Sinatra路由配置
get '/' do
  erb :index
end

# 提交投票的路由
post '/vote' do
  content_type 'application/json'
  
  # 从请求体中获取投票数据
  vote_data = JSON.parse(request.body.read)
  
  # 检查投票数据完整性
  if vote_data['option'].nil?
    status 400
    "{\"error\": \"Invalid vote data\"}"
  else
    # 向Redis添加投票
    redis.incrby \"votes:#{vote_data['option']}\", 1
    
    # 返回成功响应
    { \"message\": \"Vote submitted successfully\" }.to_json
  end
end

# 显示投票结果的路由
get '/results' do
  content_type 'application/json'
  
  # 从Redis检索投票结果
  options = redis.keys('votes:*')
  results = options.map do |option|
    { option.split(':')[1] => redis.get(option).to_i }
  end
  
  # 返回投票结果
  results.to_json
end

# 视图文件：index.erb
__END__
@@ index
<!DOCTYPE html>
<html lang=\