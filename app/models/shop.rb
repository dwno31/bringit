class Shop < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  
  has_many :orders, dependent: :destroy
  has_many :kakaoorders, dependent: :destroy
  has_many :menus
end
