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
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionAcceptedOrClosed,                 to: [Transactions::Events::TransactionAccepted,
                                                                                                            Transactions::Events::TransactionClosed])
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionRejected,                         to: [Transactions::Events::TransactionRejected])                                                                               
    store.subscribe(ReadModels::Transactions::Handlers::OnSettlementTermsAdded,                        to: [Transactions::Events::SettlementTermsAdded])
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionCheckedOut,                       to: [Transactions::Events::TransactionCheckedOut])
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionCorrected,                        to: [Transactions::Events::TransactionCorrected])
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionSettled,                          to: [Transactions::Events::TransactionSettled])
    

    store.subscribe(ReadModels::CredibilityPoints::Handlers::OnCredibilityPointsAlloted,               to: [CredibilityPoints::Events::CredibilityPointsAlloted])
    store.subscribe(ReadModels::CredibilityPoints::Handlers::OnPenaltyPointsAdded,                     to: [CredibilityPoints::Events::PenaltyPointsAdded])


    store.subscribe(ReadModels::TrustPoints::Handlers::OnTrustPointsAlloted,                           to: [TrustPoints::Events::TrustPointsAlloted])

    store.subscribe(ReadModels::Warnings::Handlers::OnTransactionExpiredWarningSent,                   to: [Warnings::Events::TransactionExpiredWarningSent])

    # Processes(System)
    store.subscribe(Processes::RankingPoint, to: [
      Transactions::Events::SettlementTermsAdded,
      Transactions::Events::TransactionSettled,
      CredibilityPoints::Events::CredibilityPointsCalculated,
      TrustPoints::Events::TrustPointsCalculated,
      Warnings::Events::TransactionExpiredWarningSent, # calculate penalty credibility points
      TrustPoints::Events::TrustPointsAlloted
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


    bus.register(CredibilityPoints::Commands::CalculateCredibilityPoints, CredibilityPoints::Handlers::OnCalculateCredibilityPoints.new)
    bus.register(CredibilityPoints::Commands::AllotCredibilityPoints,     CredibilityPoints::Handlers::OnAllotCredibilityPoints.new)
    bus.register(CredibilityPoints::Commands::AddPenaltyPoints,           CredibilityPoints::Handlers::OnAddPenaltyPoints.new)



    bus.register(TrustPoints::Commands::CalculateTrustPoints,             TrustPoints::Handlers::OnCalculateTrustPoints.new)
    bus.register(TrustPoints::Commands::AllotTrustPoints,                 TrustPoints::Handlers::OnAllotTrustPoints.new)

    bus.register(Warnings::Commands::SendTransactionExpiredWarning,       Warnings::Handlers::OnSendTransactionExpiredWarning.new)
  end

end