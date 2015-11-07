class AddCheckActiveToOrders < ActiveRecord::Migration
  def change
      add_column :orders, :check_active, :boolean
    
  end
end
