class AddColumnToMenu < ActiveRecord::Migration
  def change
	add_column :orders, :menu_order, :integer
  end
end
