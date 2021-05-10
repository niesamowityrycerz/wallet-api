desc "Build new seed without migrating and creating db"


namespace :db do 
  desc 'This task gets rid off rows from all dbs'

  task :delete_old_seed => :environment do
    User.destroy_all
    WarningType.destroy_all
    Currency.destroy_all
    HasFriendship::Friendship.destroy_all
  
    WriteModels::Debt.destroy_all
    WriteModels::GroupMember.destroy_all
    WriteModels::RepaymentCondition.destroy_all 
    WriteModels::Warning.destroy_all
    WriteModels::Group.destroy_all
  
    ReadModels::Rankings::CreditorRanking.destroy_all
    ReadModels::Rankings::DebtorRanking.destroy_all 
    ReadModels::Warnings::DebtWarningProjection.destroy_all
    ReadModels::Groups::GroupProjection.destroy_all
    ReadModels::Debts::DebtProjection.destroy_all 
  
    RailsEventStoreActiveRecord::EventInStream.delete_all
    RailsEventStoreActiveRecord::Event.delete_all
  end
end
