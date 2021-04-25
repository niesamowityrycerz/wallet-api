class Group < ApplicationRecord
  has_many :group_members, class_name: 'WriteModes::GroupMember'
  has_many :members, through: :group_members

end