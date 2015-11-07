class AddOrderCountToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :order_count, :integer
  end
end
