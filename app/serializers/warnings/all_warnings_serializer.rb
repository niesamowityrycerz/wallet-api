module Warnings 
  class AllWarningsSerializer < BaseWarningSerializer
    include JSONAPI::Serializer

    attribute :debtor do |warning| 
      debtor = User.find_by!(id: warning.user_id)
      debtor.username
    end

  end 
end