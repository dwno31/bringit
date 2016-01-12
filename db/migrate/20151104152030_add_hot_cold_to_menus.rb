class AddHotColdToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :hot_cold, :boolean
  end
end
