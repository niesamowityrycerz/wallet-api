module Groups 
  module Commands
    class CloseGroup < Command
      SCHEMA = {
        group_uid: String,
        user_id: Integer
      }
    end
  end
end