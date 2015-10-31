class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
        t.string :customer_simid
        t.string :customer_payid
      t.timestamps null: false
    end
  end
end
