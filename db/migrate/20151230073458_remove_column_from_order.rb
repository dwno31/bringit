class RemoveColumnFromOrder < ActiveRecord::Migration
  def change
	remove_column :orders, :menu_order
  end
end
