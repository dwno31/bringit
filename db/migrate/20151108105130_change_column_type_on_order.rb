class ChangeColumnTypeOnOrder < ActiveRecord::Migration
  def change
    change_column :orders, :order_list, :text
  end
end
