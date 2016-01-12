class AddColumnToShopsShopRefidToString < ActiveRecord::Migration
  def change
	add_column :shops, :shop_refid, :string
  end
end
