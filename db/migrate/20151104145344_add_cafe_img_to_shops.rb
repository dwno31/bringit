class AddCafeImgToShops < ActiveRecord::Migration
  def change
      add_column :shops, :cafe_img, :string
    
  end
end
