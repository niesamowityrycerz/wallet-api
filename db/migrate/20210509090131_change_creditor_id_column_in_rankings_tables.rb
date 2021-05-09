class ChangeCreditorIdColumnInRankingsTables < ActiveRecord::Migration[5.2]
  def change
    remove_column :creditors_ranking, :creditor_id, :integer
    remove_column :debtors_ranking,   :debtor_id,   :integer

    add_column :creditors_ranking, :creditor_name, :string
    add_column :creditors_ranking, :creditor_id,   :integer

    add_column :debtors_ranking, :debtor_name, :string
    add_column :debtors_ranking, :debtor_id,   :integer
  end
end
