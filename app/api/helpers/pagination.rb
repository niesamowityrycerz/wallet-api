module Helpers 
  module Pagination 
    extend Grape::API::Helpers 
    params :pagination do 
      optional :page, type: Integer, values: ->(val) { val >= 0 }, default: 0
    end
  end
end