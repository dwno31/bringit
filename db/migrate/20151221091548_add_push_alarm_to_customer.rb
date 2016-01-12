class AddPushAlarmToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :push_alarm, :boolean
  end
end
