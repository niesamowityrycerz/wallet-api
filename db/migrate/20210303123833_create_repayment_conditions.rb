class CreateRepaymentConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :repayment_conditions do |t|
      t.datetime :date_from
      t.datetime :date_to
      t.float :interest

      t.timestamps
    end
  end
end
