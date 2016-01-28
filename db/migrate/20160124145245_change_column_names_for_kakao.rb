class ChangeColumnNamesForKakao < ActiveRecord::Migration
  def change
	rename_column :kakaoorders, :yellow_customer_id, :kakaocustomer_id
  end
end
