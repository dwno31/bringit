class AddColumnToKakacustomerGenderString < ActiveRecord::Migration
  def change
	add_column :kakaocustomers, :gender, :string
  end
end
