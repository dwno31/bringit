class ChangeColumnInOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :menu_id
    add_column :orders, :order_list, :string
  end
end
