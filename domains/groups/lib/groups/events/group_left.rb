module Groups 
  module Events 
    class GroupLeft < Event
      SCHEMA = {
        group_uid: String,
        user_id: Integer
      }
    end
  end
end