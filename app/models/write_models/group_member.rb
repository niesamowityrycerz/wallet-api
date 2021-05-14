module WriteModels
  class GroupMember < ApplicationRecord
    belongs_to :group
    belongs_to :member, class_name: "User"

    enum invitation_status: { waiting: 0, accepted: 1, rejected: 2 }
  end
end 
