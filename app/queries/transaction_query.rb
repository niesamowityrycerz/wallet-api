class TransactionQuery
  def initialize(filters, pagination, transactions, current_user)
    @filters = filters
    @pagination = pagination
    @all_transactions = transactions
    @current_user = current_user
  end

  def call
    if !@filters[:transaction_filters].nil?
      @tran_filters = @filters[:transaction_filters]
      type_of_transactions(@tran_filters[:type]) if @tran_filters[:type] && @current_user.admin 
      amount_range(@tran_filters[:amount]) if @tran_filters[:amount]
      transaction_date_range(@tran_filters[:date_of_transaction]) if @tran_filters[:date_of_transaction]
      given_status(@tran_filters[:status]) if @tran_filters[:status] 
    end
    paginate(@pagination)
  end

  private 

  # workaround:
  # default option set in helpers/pagination.rb doesn't work 
  def paginate(info)
    if info.nil? 
      @all_transactions.page(1)
    else 
      @all_transactions.page(info[:page])
    end
  end

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

  def type_of_transactions(type)
    if type == "borrow"
      @all_transactions  = @all_transactions.where("debtor_id = ?", @current_user.id)
    elsif typ == "lend"
      @all_transactions = @all_transactions.where("creditor_id = ?", @current_user.id)
    end
  end


end

