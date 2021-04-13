class CreateCreditorsRankings < ActiveRecord::Migration[5.2]
  def change
    create_table :creditors_rankings do |t|

      t.timestamps
    end
  end
end
