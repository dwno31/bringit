class CreateKakaochatlogs < ActiveRecord::Migration
  def change
    create_table :kakaochatlogs do |t|
	  t.string :chat_id
	  t.string :nickname
	  t.text   :message
      t.timestamps null: false
    end
  end
end
