module Groups 
  module Events 
    class GroupRegistered < Event
      SCHEMA = {
        group_uid: String,
        leader_id: Integer,
        invited_users: [[Integer]],
        from: Date,
        to: Date,
        group_name: String,
        state: Symbol
      }
    end
  end
end