module Groups 
  module Events 
    class InvitationRejected < Event 
      SCHEMA = {
        user_id: Integer,
        group_uid: String,
        state: Symbol
      }
    end
  end
end