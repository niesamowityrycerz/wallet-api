module Groups 
  module Commands
    class InviteUser < Command 
      SCHEMA = {
        group_uid: String,
        user_id: Integer
      }
    end
  end
end