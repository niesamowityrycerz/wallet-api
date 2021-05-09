module Rankings
  class DebtorsRankingQuery < BaseRankingQuery
    def initialize(positions, filters, pagination)
      super(positions, filters)
      @positions = positions
      @filters = filters
      @pagination = pagination
    end

    def filter
      if !@filters.nil?
        filter_by_ratio(@filters[:ratio]) if @filters[:ratio]
        filter_by_adjusted_cred_points(@filters[:adjusted_credibility_points]) if @filters[:adjusted_credibility_points]
        filter_by_ratio(@filters[:ratio]) if @filters[:ratio]
        filter_by_debts_quantity(@filters[:debts_quantity]) if @filters[:debtss_quantity]
        filter_by_creditors_ids(@filters[:debtors_ids]) if @filters[:debtors_ids]
      end
      paginate(@pagination)
    end

    private 

    def filter_by_adjusted_cred_points(params)
      @positions = @positions.where("adjusted_credibility_points <= ? AND adjusted_credibility_points >= ?", params[:max], params[:min])
    end

    def filter_by_debts_quantity(option)
      mapper = {
        most_to_least: "DESC",
        least_to_most: "ASC"
      }
      @positions = @positions.reorder("debts_quantity #{mapper[option]}")
    end

    def filter_by_debtors_ids(creditors_ids)
      @positions = @positions.where("debtor_id IN ?", debtors_ids )
    end
  end
end 