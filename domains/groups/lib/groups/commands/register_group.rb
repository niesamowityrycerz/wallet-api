module Groups
  module Commands 
    class RegisterGroup < Command
      SCHEMA = {
        group_uid: String,
        leader_id: Integer,
        invited_users: [[Integer]],
        group_name: String,
        from: Date,
        to: Date
      }
    end
  end
end