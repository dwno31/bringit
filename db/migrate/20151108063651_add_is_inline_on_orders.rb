class AddIsInlineOnOrders < ActiveRecord::Migration
  def change
    add_column :orders, :is_inline, :boolean
  end
end
