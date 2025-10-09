# 代码生成时间: 2025-10-09 19:40:42
# ProcessManager is a Sinatra-based web application for managing processes.
class ProcessManager < Sinatra::Base
  # Endpoint to list all processes
  get '/processes' do
    # Retrieve the list of processes
    processes = `ps aux`.lines.map(&:chomp)
    content_type :json
    MultiJson.encode(processes)
  end

  # Endpoint to start a new process
  post '/start' do
    # Parse the JSON payload to determine the command to run
    command = JSON.parse(request.body.read)['command']
    if command.nil?
      status 400
      return MultiJson.encode({ error: 'Missing command' })
    end

    # Start the process in the background
    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
      process_id = wait_thr.value.pid
      content_type :json
      MultiJson.encode({ pid: process_id, message: 'Process started successfully' })
    end
  rescue => e
    # Error handling if the process fails to start
    status 500
    MultiJson.encode({ error: e.message })
  end

  # Endpoint to stop a process by PID
  post '/stop/:pid' do |pid|
    # Check if the PID is a number
    unless pid =~ /^\d+$/
      status 400
      return MultiJson.encode({ error: 'Invalid PID' })
    end

    # Terminate the process with the given PID
    system "kill -9 #{pid}"
    if $?.success?
      content_type :json
      MultiJson.encode({ message: 'Process stopped successfully' })
    else
      status 500
      MultiJson.encode({ error: 'Failed to stop process' })
    end
  rescue => e
    # Error handling if the process fails to stop
    status 500
    MultiJson.encode({ error: e.message })
  end

  # Not found handler
  not_found do
    content_type :json
    MultiJson.encode({ error: 'Not found' })
  end

  # Error handler
  error do
    content_type :json
    MultiJson.encode({ error: env['sinatra.error'].message })
  end
end

# Run the app if it's the main thread
run! if __FILE__ == $0