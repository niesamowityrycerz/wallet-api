module Rankings 
  class CreditorsRankingQuery < BaseRankingQuery
    def initialize(positions, filters, pagination)
      super(positions, filters)
      @positions = positions
      @filters = filters
      @pagination = pagination
    end

    def filter
      if !@filters.nil?
        filter_by_ratio(@filters[:ratio]) if @filters[:ratio]
        filter_by_trust_points(@filters[:trust_points]) if @filters[:trust_points]
        filter_by_ratio(@filters[:ratio]) if @filters[:ratio]
        filter_by_credits_quantity(@filters[:credits_quantity]) if @filters[:credits_quantity]
        filter_by_creditors_ids(@filters[:creditors_ids]) if @filters[:creditors_ids]
      end
      paginate(@pagination)
    end

    private 

    def filter_by_trust_points(params)
      @positions = @positions.where("trust_points <= ? AND trust_points >= ?", params[:max], params[:min])
    end

    def filter_by_credits_quantity(option)
      mapper = {
        most_to_least: "DESC",
        least_to_most: "ASC"
      }
      @positions = @positions.reorder("credits_quantity #{mapper[option]}")
    end

    def filter_by_creditors_ids(creditors_ids)
      @positions = @positions.where("creditor_id IN ?", creditors_ids )
    end
  end 
end