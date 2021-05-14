class ChangeCreditorIdColumnInRankingsTables < ActiveRecord::Migration[5.2]
  def change
    remove_column :creditor_rankings, :creditor_id, :integer
    remove_column :debtor_rankings,   :debtor_id,   :integer

    add_column :creditor_rankings, :creditor_name, :string
    add_column :creditor_rankings, :creditor_id,   :integer

    add_column :debtor_rankings, :debtor_name, :string
    add_column :debtor_rankings, :debtor_id,   :integer
  end
end
