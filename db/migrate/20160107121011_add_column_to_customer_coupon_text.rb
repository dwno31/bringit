class AddColumnToCustomerCouponText < ActiveRecord::Migration
  def change
	add_column :customers, :my_coupon, :text
  end
end
