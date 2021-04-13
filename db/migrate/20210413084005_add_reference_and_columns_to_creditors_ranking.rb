class AddReferenceAndColumnsToCreditorsRanking < ActiveRecord::Migration[5.2]
  def change
    add_reference :creditors_ranking, :creditor, references: :users, foreign_key: true 
    add_column    :creditors_ranking, :trust_points, :float, default: 0
    add_column    :creditors_ranking, :credit_transactions, :integer, default: 0
  end
end
