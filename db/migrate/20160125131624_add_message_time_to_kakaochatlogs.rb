class AddMessageTimeToKakaochatlogs < ActiveRecord::Migration
  def change
    add_column :kakaochatlogs, :message_time, :datetime
  end
end
