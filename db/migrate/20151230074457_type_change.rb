class TypeChange < ActiveRecord::Migration
  def change
	change_column :customers, :default_order, :text
  end
end
