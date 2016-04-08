@app_path = "/home/app/approot/line-bot/current"
working_directory @app_path

worker_processes 2
preload_app true
timeout 60
listen 3000

stdout_path "#{@app_path}/log/unicorn.log"
stderr_path "#{@app_path}/log/unicorn.log"

before_fork do |server, worker|
  ENV["BUNDLE_GEMFILE"] = File.expend_path("Gemfile", ENV["RAILS_ROOT"])
end

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Erron::ENOENT, Erron::ESRCH
    end
  end
end
