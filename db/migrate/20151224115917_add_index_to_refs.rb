class AddIndexToRefs < ActiveRecord::Migration
  def change
	add_index :orders, :order_refid
	add_index :shops, :shop_refid
  end
end
