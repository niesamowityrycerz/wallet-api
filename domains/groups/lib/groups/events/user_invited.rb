module Groups
  module Events 
    class UserInvited < Event 
      SCHEMA = {
        group_uid: String,
        invited_user_id: Integer
      }
    end
  end
end