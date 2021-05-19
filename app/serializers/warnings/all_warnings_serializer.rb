module Warnings 
  class AllWarningsSerializer
    include JSONAPI::Serializer

    attribute :penalty_points

    attribute :debtor do |warning| 
      debtor = User.find_by!(id: warning.user_id)
      debtor.username
    end

    attribute :warning_name do |warning|
      warning.warning_type_name
    end

    attribute :issued_at do |warning|
      warning.created_at
    end

    link :debt_details do |warning|
      "/api/v1/debt/#{warning.debt_uid}"
    end
  end 

end