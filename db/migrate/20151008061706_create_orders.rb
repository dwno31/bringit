class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
        t.integer :customer_id
        t.integer :menu_id
        t.integer :shop_id
        t.datetime :order_time
        t.string :order_option
    end
  end
end
