module Groups 
  module Commands 
    class RejectInvitation < Command 
      SCHEMA = {
        group_uid: String, 
        user_id: Integer
      }
    end
  end
end