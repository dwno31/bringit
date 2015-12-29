class AddColumnToOrderRefidToString < ActiveRecord::Migration
  def change
	add_column :orders, :order_refid, :string
  end
end
