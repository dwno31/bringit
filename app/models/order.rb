class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :menu
  belongs_to :shop
end
