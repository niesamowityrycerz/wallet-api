class AddReferenceToDebtorRankings < ActiveRecord::Migration[5.2]
  def change
    add_reference :debtor_rankings,  :debtor, foreign_key: { to_table: :users }
    add_column    :debtor_rankings,  :credibility_points, :float, default: 0.0
    add_column    :debtor_rankings,  :transaction_counter, :integer, default: 0
  end
end
