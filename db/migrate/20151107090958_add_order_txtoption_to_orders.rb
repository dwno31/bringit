class AddOrderTxtoptionToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :order_txtoption, :string
  end
end
