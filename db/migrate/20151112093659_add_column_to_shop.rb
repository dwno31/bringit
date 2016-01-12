class AddColumnToShop < ActiveRecord::Migration
  def change
    add_column :shops, :shop_loginid, :string, unique: true
  end
end
