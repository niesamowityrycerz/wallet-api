class AllWarningsSerializer < BaseWarningSerializer
  include JSONAPI::Serializer

  attribute :debtor do |warnings| 
    debtor = User.find_by!(id: warning.user_id)
    debtor.username
  end

end