module Debts 
  class BaseDebtsService 
    def initialize(params, current_user=nil)
      @debt_uid = params[:debt_uid]
      @params = params
      @current_user = current_user
    end

    attr_reader :params, :current_user, :debt_uid

    def debt_projection
      ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid)
    end

    def is_debtor?(user)
      (debt_projection.debtor_id == user.id) || user.admin
    end

    def is_creditor?(user)
      (debt_projection.creditor_id == user.id) || user.admin
    end

    def is_admin?(user)
      user.admin
    end

    def has_access?(user)
      is_creditor?(user) || is_debtor?(user) || is_admin?(user)
    end
  end
end