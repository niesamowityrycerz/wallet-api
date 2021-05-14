module Groups
  module Commands
    class LeaveGroup < Command 
      SCHEMA = {
        group_uid: String,
        member_id: Integer
      }
    end
  end
end