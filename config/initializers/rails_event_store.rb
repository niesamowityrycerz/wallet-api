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
    store.subscribe(ReadModels::Debts::Handlers::OnDebtIssued,                           to: [Debts::Events::DebtIssued])
    store.subscribe(ReadModels::Debts::Handlers::OnRepaymentConditionsOverwrote,         to: [Debts::Events::RepaymentConditionsOverwrote])
    store.subscribe(ReadModels::Debts::Handlers::OnDebtAcceptedOrClosed,                 to: [Debts::Events::DebtAccepted,
                                                                                              Debts::Events::DebtClosed])
    store.subscribe(ReadModels::Debts::Handlers::OnDebtRejected,                         to: [Debts::Events::DebtRejected])                                                                               
    store.subscribe(ReadModels::Debts::Handlers::OnAnticipatedSettlementDateAdded,       to: [Debts::Events::AnticipatedSettlementDateAdded])
    store.subscribe(ReadModels::Debts::Handlers::OnDebtDetailsCheckedOut,                to: [Debts::Events::DebtDetailsCheckedOut])
    store.subscribe(ReadModels::Debts::Handlers::OnDebtDetailsCorrected,                 to: [Debts::Events::DebtDetailsCorrected])
    store.subscribe(ReadModels::Debts::Handlers::OnDebtSettled,                          to: [Debts::Events::DebtSettled])
    

    store.subscribe(ReadModels::RankingPoints::Handlers::OnCredibilityPointsAlloted,     to: [RankingPoints::Events::CredibilityPointsAlloted])
    store.subscribe(ReadModels::RankingPoints::Handlers::OnTrustPointsAlloted,           to: [RankingPoints::Events::TrustPointsAlloted])
    store.subscribe(ReadModels::RankingPoints::Handlers::OnPenaltyPointsAdded,           to: [RankingPoints::Events::PenaltyPointsAdded])

    store.subscribe(ReadModels::Warnings::Handlers::OnMissedDebtRepaymentWarningSent,    to: [Warnings::Events::MissedDebtRepaymentWarningSent])

    
    store.subscribe(ReadModels::Groups::Handlers::OnGroupRegistered,                     to: [Groups::Events::GroupRegistered])
    store.subscribe(ReadModels::Groups::Handlers::OnGroupSettlementTermsAdded,           to: [Groups::Events::GroupSettlementTermsAdded])
    store.subscribe(ReadModels::Groups::Handlers::OnInvitationAccepted,                  to: [Groups::Events::InvitationAccepted])
    store.subscribe(ReadModels::Groups::Handlers::OnInvitationRejected,                  to: [Groups::Events::InvitationRejected])
    store.subscribe(ReadModels::Groups::Handlers::OnGroupClosed,                         to: [Groups::Events::GroupClosed])
    store.subscribe(ReadModels::Groups::Handlers::OnUserInvited,                         to: [Groups::Events::UserInvited])
    store.subscribe(ReadModels::Groups::Handlers::OnGroupLeft,                           to: [Groups::Events::GroupLeft])
    store.subscribe(ReadModels::Groups::Handlers::OnGroupLeaderChanged,                  to: [Groups::Events::GroupLeaderChanged])
    
                                                                                  
    store.subscribe(Processes::DebtPoint, to: [
      Debts::Events::DebtAccepted,
      Debts::Events::DebtSettled,
      Warnings::Events::MissedDebtRepaymentWarningSent,  
      RankingPoints::Events::TrustPointsAlloted,
    ])
    
  end

  Rails.configuration.command_bus.tap do |bus|
    bus.register(Debts::Commands::IssueDebt,                            Debts::Handlers::OnIssueDebt.new)
    bus.register(Debts::Commands::OverwriteRepaymentConditions,         Debts::Handlers::OnOverwriteRepaymentConditions.new)
    bus.register(Debts::Commands::AcceptDebt,                           Debts::Handlers::OnAcceptDebt.new)
    bus.register(Debts::Commands::RejectDebt,                           Debts::Handlers::OnRejectDebt.new)
    bus.register(Debts::Commands::AddAnticipatedSettlementDate,         Debts::Handlers::OnAddAnticipatedSettlementDate.new)
    bus.register(Debts::Commands::CloseDebt,                            Debts::Handlers::OnCloseDebt.new)
    bus.register(Debts::Commands::CheckOutDebtDetails,                  Debts::Handlers::OnCheckOutDebtDetails.new)
    bus.register(Debts::Commands::CorrectDebtDetails,                   Debts::Handlers::OnCorrectDebtDetails.new)
    bus.register(Debts::Commands::SettleDebt,                           Debts::Handlers::OnSettleDebt.new)

    bus.register(RankingPoints::Commands::AllotCredibilityPoints,           RankingPoints::Handlers::OnAllotCredibilityPoints.new)
    bus.register(RankingPoints::Commands::AddPenaltyPoints,                 RankingPoints::Handlers::OnAddPenaltyPoints.new)
    bus.register(RankingPoints::Commands::AllotTrustPoints,                 RankingPoints::Handlers::OnAllotTrustPoints.new)

    bus.register(Warnings::Commands::SendMissedDebtRepaymentWarning,       Warnings::Handlers::OnSendMissedDebtRepaymentWarning.new)

    bus.register(Groups::Commands::RegisterGroup,                         Groups::Handlers::OnRegisterGroup.new)
    bus.register(Groups::Commands::AddGroupSettlementTerms,               Groups::Handlers::OnAddGroupSettlementTerms.new)
    bus.register(Groups::Commands::AcceptInvitation,                      Groups::Handlers::OnAcceptInvitation.new)
    bus.register(Groups::Commands::RejectInvitation,                      Groups::Handlers::OnRejectInvitation.new)
    bus.register(Groups::Commands::CloseGroup,                            Groups::Handlers::OnCloseGroup.new)
    bus.register(Groups::Commands::InviteUser,                            Groups::Handlers::OnInviteUser.new)
    bus.register(Groups::Commands::LeaveGroup,                            Groups::Handlers::OnLeaveGroup.new)
  end

end