RSpec.configure do |config|
  # before the entire test suite runs, clear the test database out completely
  # set fats cleanup startegy: transaction
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  # hook up database_cleaner around the beginning and end of test suite, telling it to execute whatever cleanup strategy we selected beforehand.
  config.before(:each) do
    DatabaseCleaner.start
    
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end