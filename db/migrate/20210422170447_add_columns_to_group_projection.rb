class AddColumnsToGroupProjection < ActiveRecord::Migration[5.2]
  def change
    add_column :group_projections, :transactions_expired_on, :date
    add_column :group_projections, :currency, :string
    add_column :group_projections, :state, :integer
  end
end
