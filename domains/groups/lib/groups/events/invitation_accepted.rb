module Groups 
  module Events 
    class InvitationAccepted < Event 
      SCHEMA = {
        member_id: Integer,
        group_uid: String,
        state: Symbol
      }
    end
  end
end