module Groups
  module Events
    class GroupClosed < Event
      SCHEMA = {
        group_uid: String,
        status: Symbol
      }
    end
  end
end