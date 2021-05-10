module Rankings
  class CreditorRankingSerializer
    include JSONAPI::Serializer 

    attributes :trust_points, :credits_quantity, :ratio

    attribute :creditor do |position|
      user = User.find_by!(id: position.creditor_id)
      user.username
    end
  end
end