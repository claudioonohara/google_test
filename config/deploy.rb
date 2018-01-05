# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "google_test"
set :repo_url, "git@github.com:claudioonohara/google_test.git"

# Definições padrões do Rbenv
    set :rbenv_ruby, File.read('.ruby-version').strip  
    set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"  
    set :rbenv_roles, :all
    
    # Repare nesse caminho, eh o mesmo onde ficara o banco de dados da produção
    set :deploy_to, '/home/claudioonohara/apps/google_test'
    
    # Linka arquivos e pastas
    append :linked_files, 'config/database.yml', 'config/secrets.yml', 'config/application.yml'
    
    append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'
    
    # Define a quantidade de releases no server
    set :keep_releases, 1
    
    # Definições da task upload dentro do namespace figaro
    namespace :figaro do  
      task :upload do    
        on roles(:all) do
          # cria a pasta shared/config antes de mandar os arquivos pra lá
          execute "mkdir -p #{shared_path}/config"
    
          upload! 'config/secrets.yml', "#{shared_path}/config/secrets.yml"
          upload! 'config/database.yml', "#{shared_path}/config/database.yml"
          upload! 'config/application.yml', "#{shared_path}/config/application.yml"
        end
      end
    end
    
    # Rodar antes do check deploy a task upload (logo acima)
    before 'deploy:check', 'figaro:upload' 


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
