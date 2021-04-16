module Helpers 
  module Pagination 
    extend Grape::API::Helpers 

    params :pagination do 
      optional :page, type: Integer, default: 0
    end


  end
end