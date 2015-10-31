class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
        t.string :shop_location
        t.string :shop_name
        
    end
  end
end
