class AddDeciamlOptionToFloatTypeColumns < ActiveRecord::Migration[5.2]
  def change
    change_column :creditors_ranking, :ratio, :decimal, precision: 2, scale: 2 
    change_column :debtors_ranking,   :ratio, :decimal, precision: 2, scale: 2 
  end
end
