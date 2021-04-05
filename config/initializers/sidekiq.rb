
Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379' }
end

# do not run background process again
# if it Sidekiq fails to deliver it 
Sidekiq.default_worker_options = {
  retry: false
}

