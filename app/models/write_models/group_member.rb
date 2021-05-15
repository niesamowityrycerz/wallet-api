module WriteModels
  class GroupMember < ApplicationRecord
    belongs_to :group
    belongs_to :member, class_name: "User"

    enum invitation_status: { waiting: 'waiting', accepted: 'accepted', rejected: 'rejected' }
  end
end 
