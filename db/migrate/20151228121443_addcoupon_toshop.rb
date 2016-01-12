class AddcouponToshop < ActiveRecord::Migration
  def change
	add_column :shops, :coupon, :integer
  end
end
