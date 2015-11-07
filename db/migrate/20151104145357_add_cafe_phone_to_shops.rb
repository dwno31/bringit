class AddCafePhoneToShops < ActiveRecord::Migration
  def change
      add_column :shops, :cafe_phone, :string
    
  end
end
