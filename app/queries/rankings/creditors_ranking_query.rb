module Rankings 
  class CreditorsRankingQuery 
    def initialize(positions, filters, pagination)
      @positions = positions
      @filters = filters
      @pagination = pagination
      binding.pry
    end

    def filter
      binding.pry 
      if !@filters.nil?
        filter_by_ratio(@filters[:ratio]) if @filters[:ratio]
        filter_by_trust_points(@filters[:trust_points]) if @filters[:trust_points]
        filter_by_ratio(@filters[:ratio]) if @filters[:ratio]
        filter_by_credits_quantity(@filters[:credits_quantity]) if @filters[:credits_quantity]
      end
      paginate(@pagination)
    end

    private 

    def paginate(page_number)
      binding.pry 
      if page_number.nil?
        @positions.page(0)
      else
         @positions.page(page_number)
      end 
    end

    def filter_by_ratio(option)
      mapper = {
        highest_to_lowest: "DESC",
        lowest_to_biggest: "ASC"
      }
      numerator = @positions.select("trust_points")
      denumerator = @positions.select("credits_quantity")
      ratio = 
      @positions = @positions.order("ratio, #{mapper[option]}")
      binding.pry
    end

    def filter_by_trust_points(min, max)
      @positions = @positions.where("trust_points <= ? AND trust_points >= ?", max, min)
    end

    def filter_by_credits_quantity(option)
      mapper = {
        most_to_least: "DESC",
        least_to_most: "ASC"
      }
      @positions = @positions.where("credits_quantity, #{mapper[option]}")
    end
  end 
end