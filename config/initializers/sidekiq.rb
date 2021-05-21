# redis size == sidekiq concurrency
Sidekiq.configure_server do |config|
  config.redis = { 
    network_timeout: 5,
    url: ENV['REDIS_URL']
  }
end

# it is recommended to keep +2 buffer value 
# for Sidekiq redis config server value above

### update ###
# if you don't specify redis size, 
# sidekiq will auto-size my pools
Sidekiq.configure_client do |config|
  config.redis = { 
    network_timeout: 5,
    url: ENV['REDIS_URL']
  }
end

# do not run background process again
# if Sidekiq fails to deliver it 
Sidekiq.default_worker_options = {
  retry: false
}

