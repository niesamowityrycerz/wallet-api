module Groups 
  module Commands 
    class AcceptInvitation < Command
      SCHEMA = {
        group_uid: String,
        member_id: Integer
      }
    end
  end
end