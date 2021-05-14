class AddReferenceAndColumnsToCreditorsRanking < ActiveRecord::Migration[5.2]
  def change
    add_reference :creditor_rankings, :creditor, foreign_key: { to_table: :users} 
    add_column    :creditor_rankings, :trust_points, :float, default: 0
    add_column    :creditor_rankings, :credit_transactions, :integer, default: 0
  end
end
