module Groups 
  module Commands
    class CloseGroup < Command
      SCHEMA = {
        group_uid: String,
        leader_id: Integer
      }
    end
  end
end