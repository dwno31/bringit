class ChangeColumnTypeShop < ActiveRecord::Migration
  def change
	change_column :shops, :location_distant, :integer
  end
end
