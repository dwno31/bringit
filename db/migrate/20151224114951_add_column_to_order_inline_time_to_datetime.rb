class AddColumnToOrderInlineTimeToDatetime < ActiveRecord::Migration
  def change
	add_column :orders, :inline_time, :datetime
  end
end
