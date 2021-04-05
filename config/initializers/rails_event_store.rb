require 'arkency/command_bus'
require 'rails_event_store'

require 'aggregate_root'

Rails.configuration.to_prepare do

  Rails.configuration.event_store = event_store = RailsEventStore::Client.new
  Rails.configuration.command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  Rails.configuration.event_store.tap do |store|
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionIssued,                           to: [Transactions::Events::TransactionIssued])
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionAcceptedOrClosed,                 to: [Transactions::Events::TransactionAccepted,
                                                                                                            Transactions::Events::TransactionClosed])
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionRejected,                         to: [Transactions::Events::TransactionRejected])                                                                               
    store.subscribe(ReadModels::Transactions::Handlers::OnSettlementTermsAdded,                        to: [Transactions::Events::SettlementTermsAdded])
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionCheckedOut,                       to: [Transactions::Events::TransactionCheckedOut])
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionCorrected,                        to: [Transactions::Events::TransactionCorrected])
    store.subscribe(ReadModels::Transactions::Handlers::OnTransactionSettled,                          to: [Transactions::Events::TransactionSettled])
    

    store.subscribe(ReadModels::RankingPoints::Handlers::OnCredibilityPointsAlloted,               to: [RankingPoints::Events::CredibilityPointsAlloted])
    store.subscribe(ReadModels::RankingPoints::Handlers::OnTrustPointsAlloted,                     to: [RankingPoints::Events::TrustPointsAlloted])
    store.subscribe(ReadModels::RankingPoints::Handlers::OnPenaltyPointsAdded,                     to: [RankingPoints::Events::PenaltyPointsAdded])

    store.subscribe(ReadModels::Warnings::Handlers::OnTransactionExpiredWarningSent,                   to: [Warnings::Events::TransactionExpiredWarningSent])

    # Processes(System)
    store.subscribe(Processes::TransactionPoint, to: [
      Transactions::Events::SettlementTermsAdded,
      Transactions::Events::TransactionSettled,
      Warnings::Events::TransactionExpiredWarningSent, 
      RankingPoints::Events::TrustPointsAlloted,
    ])

    
  end

  Rails.configuration.command_bus.tap do |bus|
    bus.register(Transactions::Commands::IssueTransaction,       Transactions::Handlers::OnIssueTransaction.new)
    bus.register(Transactions::Commands::AcceptTransaction,      Transactions::Handlers::OnAcceptTransaction.new)
    bus.register(Transactions::Commands::RejectTransaction,      Transactions::Handlers::OnRejectTransaction.new)
    bus.register(Transactions::Commands::AddSettlementTerms,     Transactions::Handlers::OnAddSettlementTerms.new)
    bus.register(Transactions::Commands::CloseTransaction,       Transactions::Handlers::OnCloseTransaction.new)
    bus.register(Transactions::Commands::CheckOutTransaction,    Transactions::Handlers::OnCheckOutTransaction.new)
    bus.register(Transactions::Commands::CorrectTransaction,     Transactions::Handlers::OnCorrectTransaction.new)
    bus.register(Transactions::Commands::SettleTransaction,      Transactions::Handlers::OnSettleTransaction.new)

    bus.register(RankingPoints::Commands::AllotCredibilityPoints,           RankingPoints::Handlers::OnAllotCredibilityPoints.new)
    bus.register(RankingPoints::Commands::AddPenaltyPoints,                 RankingPoints::Handlers::OnAddPenaltyPoints.new)
    bus.register(RankingPoints::Commands::AllotTrustPoints,                 RankingPoints::Handlers::OnAllotTrustPoints.new)

    bus.register(Warnings::Commands::SendTransactionExpiredWarning,       Warnings::Handlers::OnSendTransactionExpiredWarning.new)
  end

end