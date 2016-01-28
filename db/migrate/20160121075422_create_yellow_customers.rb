class CreateYellowCustomers < ActiveRecord::Migration
  def change
    create_table :yellow_customers do |t|
		t.string :nick
		t.string :chatid
		t.string :txnid
		t.text :coupon
		t.string :phone
		t.string :bday
		

      t.timestamps null: false
    end
  end
end
