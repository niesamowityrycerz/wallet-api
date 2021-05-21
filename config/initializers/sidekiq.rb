
# different redis conntection 
# depending on env
if Rails.env.production?
  redis_url = ENV['REDIS_URL']
else
  redis_url = 'redis://localhost:6379/0'
end

Sidekiq.configure_server do |config|
  config.redis = { 
    network_timeout: 5,
    url: redis_url
  }
end


### update ###
# if you don't specify redis size, 
# sidekiq will auto-size my 
Sidekiq.configure_client do |config|
  config.redis = { 
    network_timeout: 5,
    url: redis_url
  }
end

# do not run background process again
# if Sidekiq fails to deliver it 
Sidekiq.default_worker_options = {
  retry: false
}

