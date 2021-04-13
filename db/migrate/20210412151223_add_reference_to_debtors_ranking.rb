class AddReferenceToDebtorsRanking < ActiveRecord::Migration[5.2]
  def change
    add_reference :debtors_ranking, :debtor, references: :users, foreign_key: true
    add_column    :debtors_ranking,  :credibility_points, :float, default: 0.0
    add_column    :debtors_ranking,  :transaction_counter, :integer, default: 0
  end
end
