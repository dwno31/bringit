# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


customer = Customer.create(customer_simid: 'hello', customer_payid: 'oldman')
shop = Shop.create(shop_name: '매머드알바', shop_location: '지도코드')
Menu.create(menu_title: '아이스 아메리카노', menu_price: 3800, shop_id: 1)
Menu.create(menu_title: '아이스 카페라떼', menu_price: 4800, shop_id: 1)
Menu.create(menu_title: '아이스 카푸치노', menu_price: 3800, shop_id: 1)
Menu.create(menu_title: '아이스 카라멜마키아토', menu_price: 3500, shop_id: 1)
Menu.create(menu_title: '아이스 히히머하지', menu_price: 2800, shop_id: 1)
Menu.create(menu_title: '아이스 메롱이다', menu_price: 1800, shop_id: 1)