module Groups 
  class RunAll
    def self.call(groups_q=5)
      RegisterGroup.new(groups_q)
    end
  end
end