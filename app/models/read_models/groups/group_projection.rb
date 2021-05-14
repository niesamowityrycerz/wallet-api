module ReadModels
  module Groups 
    class GroupProjection < ApplicationRecord
      has_one :group, class_name: "WriteModels::Group"

      enum state: { init: 0, terms_added: 1, closed: 2 }

    end
  end 
end 
