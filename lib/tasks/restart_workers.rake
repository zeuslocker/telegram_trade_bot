namespace :app do
  namespace :workers do
    desc 'Restart workers'
    task restart: :environment do
      sh "kill -TERM `cat #{Rails.root}/tmp/pids/sneakers.pid` || echo 'No running workers'"
      sh "rake sneakers:run WORKERS=BotWorker,TestWorker RAILS_ENV=#{Rails.env}"
    end
  end
end
