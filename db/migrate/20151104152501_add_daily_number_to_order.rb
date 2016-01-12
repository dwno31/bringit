class AddDailyNumberToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :daily_number, :string
  end
end
