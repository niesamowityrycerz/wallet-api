class DebtQuery
  def initialize(filters, pagination, debts, current_user)
    @filters = filters
    @pagination = pagination
    @all_debts = debts
    @current_user = current_user
  end

  def call
    if !@filters[:debts_filters].nil?
      @debt_filters = @filters[:debts_filters]
      type_of_debts(@debt_filters[:type]) if @debt_filters[:type] && @current_user.admin
      creditors(@debt_filters[:users]) if @debt_filters[:users]
      amount_range(@debt_filters[:amount]) if @debt_filters[:amount]
      debt_date_range(@debt_filters[:date_of_debt]) if @debt_filters[:date_of_debt]
      given_status(@debt_filters[:status]) if @debt_filters[:status] 
    end
    paginate(@pagination)
  end

  private 

  # workaround:
  # default option set in helpers/pagination.rb doesn't work 
  def paginate(info)
    if info.nil? 
      @all_debts.page(1)
    else 
      @all_debts.page(info[:page])
    end
  end

  def creditors(users)
    @all_debts = @all_debts.where(creditor_id: users)
  end

  def amount_range(amount_range)
    @all_debts = @all_debts.where("amount <= ? AND amount >= ?", amount_range[:max], amount_range[:min] )
  end

  def debt_date_range(date_range)
    @all_debts = @all_debts.where("date_of_transaction <= ? AND date_of_transaction >= ?", date_range[:to], date_range[:from])
  end

  def given_status(status_array)
    mapper = {
      "pending": 0,
      "accepted": 1,
      "rejected": 2
    }
    status_array.map! { |status| mapper[status.to_sym] }
    if status_array.count == 1 
      @all_debts = @all_debts.where("status = ?", status_array[0])
    elsif status_array.count == 2
      @all_debts = @all_debts.where("status = ? OR status = ?", status_array[0], status_array[1])
    else 
      @all_debts = @all_debts.where("status = ? OR status = ? OR status = ?", status_array[0], status_array[1], status_array[2])
    end 
    @all_debts
  end

  def type_of_debts(type)
    if type == "borrow"
      @all_debts  = @all_debts.where("debtor_id = ?", @current_user.id)
    elsif typ == "lend"
      @all_debts = @all_debts.where("creditor_id = ?", @current_user.id)
    end
  end


end

