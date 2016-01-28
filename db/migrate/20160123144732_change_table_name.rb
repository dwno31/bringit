class ChangeTableName < ActiveRecord::Migration
  def change
	rename_table :yellow_orders, :kakaoorders
	rename_table :yellow_customers, :kakaocustomers

  end
end
