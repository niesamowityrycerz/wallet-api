class AddEnumeratorsToDebtsDebtsProjectionAndGroupProjections < ActiveRecord::Migration[5.2]
  def change
    create_enum :debt_statuses, %w[pending accepted rejected under_scrutiny 
                                    closed corected settled expired debtor_terms_added
                                    points_alloted penalty_points_alloted]
    add_column :debt_projections, :status, :debt_statuses, default: 'pending'

    create_enum :general_debt_statuses, %w[pending accepted rejected
                                           closed settled expired]
    add_column :debts, :status, :general_debt_statuses, default: 'pending'

    create_enum :group_statuses, %w[init terms_added closed]
    add_column :group_projections, :status, :group_statuses, default: 'init'
  end
end
