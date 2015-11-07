class Shop < ActiveRecord::Base
  has_many :orders, dependent: :destroy
  has_many :menus
end
