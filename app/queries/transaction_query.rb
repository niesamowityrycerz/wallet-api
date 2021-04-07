class TransactionQuery
  def initialize(filters, transactions)
    @filters = filters
    @all_transactions = transactions
  end

  def call
    # call filters 
    if @filters == {} 
      @all_transactions
    else
      @filters = @filters[:transaction_filters]
      amount_range(@filters[:amount]) if @filters[:amount]
      transaction_date_range(@filters[:date_of_transaction]) if @filters[:date_of_transaction]
      given_status(@filters[:status]) if @filters[:status] 
    end
    @all_transactions
  end

  private 

  def amount_range(amount_range)
    @all_transactions = @all_transactions.where("amount <= ? AND amount >= ?", amount_range[:max], amount_range[:min] )
  end

  def transaction_date_range(date_range)
    @all_transactions = @all_transactions.where("date_of_transaction <= ? AND date_of_transaction >= ?", date_range[:to], date_range[:from])
  end

  def given_status(status_array)
    mapper = {
      "pending": 0,
      "accepted": 1,
      "rejected": 2
    }
    status_array.map! { |status| mapper[status.to_sym] }
    if status_array.count == 1 
      @all_transactions = @all_transactions.where("status = ?", status_array[0])
    elsif status_array.count == 2
      @all_transactions = @all_transactions.where("status = ? OR status = ?", status_array[0], status_array[1])
    else 
      @all_transactions = @all_transactions.where("status = ? OR status = ? OR status = ?", status_array[0], status_array[1], status_array[2])
    end 
    @all_transactions
  end

  def given_debtors(debtors_array)
    #TODO
  end


end

