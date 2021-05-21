class SimpleTestJob
  include Sidekiq::Worker

  def perform
    puts 'This should be working.'
  end
end