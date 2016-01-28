class Kakaocustomer < ActiveRecord::Base
 has_many :kakaoorders, dependent: :destroy
end
