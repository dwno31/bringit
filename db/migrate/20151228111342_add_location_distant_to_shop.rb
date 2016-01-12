class AddLocationDistantToShop < ActiveRecord::Migration
  def change
	add_column :shops, :location_distant, :string
  end
end
