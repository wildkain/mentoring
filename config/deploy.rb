# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'mentoring'
set :repo_url, 'https://github.com/wildkain/mentoring.git'
set :sidekiq_pid, File.join(shared_path, 'pids', 'sidekiq.pid')

set :rvm_ruby_version, '2.3.3'
set :rails_env, :production
set :deploy_to, "/home/deployer/mentoring"

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', '.env')
# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'pids', 'tmp/cache', 'vendor/bundle', 'public/system', 'tmp/pids', 'tmp/sockets')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5


namespace :deploy do
  desc "Reatart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      #execute :touch, release_path.join('/tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end