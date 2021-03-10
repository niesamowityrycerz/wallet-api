class AddReferencesToFaithPoints < ActiveRecord::Migration[5.2]
  def change
    add_reference :faith_points, :creditor, references: :users, index: true 
    add_reference :faith_points, :transaction_projection
  end
end
