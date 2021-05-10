module Rankings
  class DebtorRankingSerializer
    include JSONAPI::Serializer 

    attributes :adjusted_credibility_points, :debts_quantity, :ratio

    attribute :debtor do |position|
      debtor = User.find_by!(id: position.debtor_id)
      debtor.username
    end  
  end
end