require 'arkency/command_bus'
require 'rails_event_store'

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
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionIssued,                           to: [Transactions::Events::TransactionIssued])
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionAcceptedRejectedPendingOrClosed,  to: [Transactions::Events::TransactionAccepted,
                                                                                                            Transactions::Events::TransactionRejected,
                                                                                                            Transactions::Events::TransactionClosed])
    store.subscribe(ReadModels::Transactions::Handlers::OnCreditorInformed,                      to: [Transactions::Events::CreditorInformed])
    store.subscribe(ReadModels::Transactions::Handlers::OnSettlementTermsAdded,                  to: [Transactions::Events::SettlementTermsAdded])
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionCheckedOut,                 to: [Transactions::Events::TransactionCheckedOut])
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionCorrected,                  to: [Transactions::Events::TransactionCorrected])
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionSettled,                    to: [Transactions::Events::TransactionSettled])

    store.subscribe(ReadModels::TransactionPoints::Handlers::OnCredibilityPointsAlloted,      to: [TransactionPoints::Events::CredibilityPointsAlloted])
    store.subscribe(ReadModels::TransactionPoints::Handlers::OnFaithPointsAlloted,            to: [TransactionPoints::Events::FaithPointsAlloted])
    

    # Processes(System)
    store.subscribe(Processes::TransactionPoint, to: [
      Transactions::Events::TransactionSettled,
      TransactionPoints::Events::CredibilityPointsCalculated
    ])
    
  end
  
  # Register command handlers below
  # Command to handler
  Rails.configuration.command_bus.tap do |bus|
    bus.register(Transactions::Commands::IssueTransaction,       Transactions::Handlers::OnIssueTransaction.new)
    bus.register(Transactions::Commands::AcceptTransaction,      Transactions::Handlers::OnAcceptTransaction.new)
    bus.register(Transactions::Commands::RejectTransaction,      Transactions::Handlers::OnRejectTransaction.new)
    bus.register(Transactions::Commands::AddSettlementTerms,     Transactions::Handlers::OnAddSettlementTerms.new)
    bus.register(Transactions::Commands::CloseTransaction,       Transactions::Handlers::OnCloseTransaction.new)
    bus.register(Transactions::Commands::CheckOutTransaction,    Transactions::Handlers::OnCheckOutTransaction.new)
    bus.register(Transactions::Commands::CorrectTransaction,     Transactions::Handlers::OnCorrectTransaction.new)
    bus.register(Transactions::Commands::SettleTransaction,      Transactions::Handlers::OnSettleTransaction.new)

    bus.register(TransactionPoints::Commands::CalculateCredibilityPoints, TransactionPoints::Handlers::OnCalculateCredibilityPoints.new)
    bus.register(TransactionPoints::Commands::CalculateFaithPoints,       TransactionPoints::Handlers::OnCalculateFaithPoints.new)
  end

end