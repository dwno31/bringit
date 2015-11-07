class AddMenuOptionToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :menu_option, :string
  end
end
