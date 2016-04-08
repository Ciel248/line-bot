set :application, "line-bot"
set :repo_url, "https://github.com/Ciel248/line-bot.git"
set :branch, "master"
set :deploy_to, "/home/app/approot/line-bot"
set :scm, :git
set :linked_dirs, %w[
  bin
  log
  tmp/pids
  tmp/sockets
  bundle
  public/system
]
set :default_env, { path: "/home/app/.rbenv/shims:/home/app/.rbenv/bin:$PATH" }
set :keep_releases, 5

after "deploy:publishing", "deploy:restart"
namespace :deploy do
  desc "restart application"
  task :restart do
    invoke "unicorn:restart"
  end
end
