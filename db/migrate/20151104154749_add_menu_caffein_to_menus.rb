class AddMenuCaffeinToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :caffeine, :boolean
  end
end
