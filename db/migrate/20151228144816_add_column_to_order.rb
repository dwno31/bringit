class AddColumnToOrder < ActiveRecord::Migration
  def change
	add_column :orders, :complete_time, :datetime
  end
end
