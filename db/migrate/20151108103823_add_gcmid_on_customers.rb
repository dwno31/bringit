class AddGcmidOnCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :gcmid, :string
  end
end
