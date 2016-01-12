class OrderColumnConfig < ActiveRecord::Migration
  def change
    remove_column :orders, :order_option
    remove_column :orders, :order_txtoption
  end
end
