class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
          t.integer :menu_price
          t.integer :shop_id
          t.string :menu_title  
      
    end
  end
end
