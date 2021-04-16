module Helpers
  module SortBy 
    extend Grape::Api::Helpers 

    params :sort_by do 
      optional :date_of_transaction, type: Hash do 
        optional :from, type: Date 
        optional :to, type: Date
      end 
      optional :amount, type: Hash do 
        optional :highest, type: Boolean
        optional :lowest , type: Boolean
        mutually_exclusive :highest, :lowest 
      end 
      optional :maturity, type: Hash do 
        optional :closet, type: Boolean
        optional :farest, type: Boolean
        mutually_exclusive :closet, :farest 
      end 
    end
  end
end