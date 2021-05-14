module Groups 
  module Events 
    class GroupLeaderChanged < Event 
      SCHEMA = {
        group_uid: String,
        new_leader_id: Integer
      }
    end
  end
end