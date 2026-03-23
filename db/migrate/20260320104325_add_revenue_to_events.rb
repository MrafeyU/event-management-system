class AddRevenueToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :revenue, :integer, default: 0
  end
end
