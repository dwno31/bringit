class CreateYellowOrders < ActiveRecord::Migration
  def change
    create_table :yellow_orders do |t|
		t.string :zone
		t.integer :shop_id
		t.integer :yellow_customer_id
		t.integer :menu_id
		t.text :token
		t.string :merchant_refid
		t.string :option
		t.string :custom
		t.integer :price
		t.datetime :order_time
		t.string :order_status
		t.string :payment_status

      t.timestamps null: false
    end
  end
end
