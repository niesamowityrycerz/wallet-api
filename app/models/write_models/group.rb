module WriteModels
  class Group < ApplicationRecord
    has_many :group_members, class_name: 'WriteModels::GroupMember'
    has_many :members, through: :group_members

    belongs_to :group_projection, class_name: 'ReadModels::Groups::GroupProjection'

  end
end 