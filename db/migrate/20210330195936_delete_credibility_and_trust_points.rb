class DeleteCredibilityAndTrustPoints < ActiveRecord::Migration[5.2]
  def change
    drop_table :credibility_points
    drop_table :trust_points
  end
end
