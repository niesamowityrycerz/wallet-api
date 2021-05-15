module ReadModels
  module Groups 
    class GroupProjection < ApplicationRecord
      has_one :group, class_name: "WriteModels::Group"

      enum status: { init: 'init', terms_added: 'terms_added', closed: 'closed' }

    end
  end 
end 
