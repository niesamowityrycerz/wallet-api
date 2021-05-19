module Rankings
  class BaseRankingQuery
    def initialize(positions, filters)
      @positions = positions
      @filters = filters 
    end

    private 

    def filter_by_ratio(option)
      mapper = {
        highest_to_lowest: "DESC",
        lowest_to_highest: "ASC"
      }
      @positions = @positions.reorder("ratio #{mapper[option]}")
    end

    def paginate(page_number)
      if page_number.nil?
        @positions.page(0)
      else
         @positions.page(page_number[:page])
      end 
    end
  end
end 