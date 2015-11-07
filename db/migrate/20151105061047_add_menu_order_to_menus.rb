class AddMenuOrderToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :menu_order, :float
    change_column :menus, :hot_cold, :integer
    change_column :menus, :caffeine, :integer
  end
end
