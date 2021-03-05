class FixForeignKeyInRepamymentConditions < ActiveRecord::Migration[5.2]
  def change
    remove_reference :repayment_conditions, :repayment_types
    add_reference    :repayment_conditions, :repayment_type, index: true, foreign_key: true
  end
end
