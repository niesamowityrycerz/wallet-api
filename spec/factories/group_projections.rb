FactoryBot.define do
  factory :group_projection do
    group_uid { "MyString" }
    name { "MyString" }
    leader_id { 1 }
    members { "" }
    from { "2021-04-22" }
    to { "2021-04-22" }
  end
end
