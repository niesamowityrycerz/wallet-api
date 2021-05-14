class AddDeciamlOptionToFloatTypeColumns < ActiveRecord::Migration[5.2]
  def change
    change_column :creditor_rankings, :ratio, :decimal, precision: 10, scale: 2 
    change_column :debtor_rankings,   :ratio, :decimal, precision: 10, scale: 2
  end
end
