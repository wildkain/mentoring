deploy_to  = '/home/deployer/mentoring'
rails_root = "#{deploy_to}/current"
pid          "#{deploy_to}/shared/tmp/pids/unicorn.pid"


worker_processes 2 # Здесь тоже в зависимости от нагрузки, погодных условий и текущей фазы луны
listen "#{deploy_to}/shared/tmp/sockets/unicorn.mentoring.sock", backlog: 64
stderr_path "log/unicorn.stderr.log"
stdout_path "log/unicorn.stdout.log"

preload_app true # Мастер процесс загружает приложение, перед тем, как плодить рабочие процессы.

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{rails_root}/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
  # Ниже идет магия, связанная с 0 downtime deploy.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # После того как рабочий процесс создан, он устанавливает соединение с базой.
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end