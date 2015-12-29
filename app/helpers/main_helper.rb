module MainHelper
def self.check_coupon(user_sim, shop_id)
    selected_user = Customer.where("customer_simid=?",user_sim).take
    selected_shop = Shop.find(shop_id)
    bought_cups = selected_user.orders.where("shop_id=?",shop_id).size
	coupon_size = selected_shop.coupon

    if bought_cups == 0
         return -1
    else
         return (bought_cups % coupon_size)
    end
 end

end
