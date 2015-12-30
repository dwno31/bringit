class AddColumnToCustomerDefault < ActiveRecord::Migration
  def change
	add_column :customers, :default_order, :string
  end
end
