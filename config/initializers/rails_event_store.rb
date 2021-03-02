require 'arkency/command_bus'
require 'rails_event_store'
# where is that file?
require 'aggregate_root'

Rails.configuration.to_prepare do

  Rails.configuration.event_store = event_store = RailsEventStore::Client.new
  Rails.configuration.command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  # subscribe event handlers below
  # READ_MODEL(event handlers) to event 
  Rails.configuration.event_store.tap do |store|
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionIssued, to: [Transactions::Events::TransactionIssued])

  end
  
  # Register command handlers below
  # Command to command handler
  Rails.configuration.command_bus.tap do |bus|
    bus.register(Transactions::Commands::IssueTransaction, Transactions::Handlers::OnIssueTransaction.new)
  end

end