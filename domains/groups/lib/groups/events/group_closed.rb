module Groups
  module Events
    class GroupClosed < Event
      SCHEMA = {
        group_uid: String,
        state: Symbol
      }
    end
  end
end