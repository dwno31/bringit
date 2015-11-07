# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Shop.create(shop_location:"신촌", cafe_img:"http://bringit-production-dwno31.c9.io/ngn_cafe.jpg", shop_name:"뉴기니 버드", cafe_phone:"010-9596-7403")

Menu.create(menu_title: "아메리카노", menu_price: 2500, shop_id: 1, hot_cold: 0, caffeine: 0, menu_option: "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500")
Menu.create(menu_title: "카페라떼", menu_price: 3100, shop_id: 1, hot_cold: 0, caffeine: 0, menu_option: "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500,우유:우유_0/저지방우유_0/두유_0")
Menu.create(menu_title: "카페모카", menu_price: 3400, shop_id: 1, hot_cold: 0, caffeine: 0, menu_option: "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500")
Menu.create(menu_title: "카푸치노", menu_price: 3400, shop_id: 1, hot_cold: 0, caffeine: 0, menu_option: "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500,우유:우유_0/저지방우유_0/두유_0")
Menu.create(menu_title: "카라멜마키아또", menu_price: 3700, shop_id: 1, hot_cold: 0, caffeine: 0, menu_option: "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500")
Menu.create(menu_title: "그린티라떼", menu_price: 3400, shop_id: 1, hot_cold: 0, caffeine: 1, menu_option: "Size:Regular_0/Large_300/Jumbo_500,우유:우유_0/저지방우유_0/두유_0")
Menu.create(menu_title: "고구마라떼", menu_price: 3400, shop_id: 1, hot_cold: 0, caffeine: 1, menu_option: "Size:Regular_0/Large_300/Jumbo_500,우유:우유_0/저지방우유_0/두유_0")
Menu.create(menu_title: "핫초코", menu_price: 3100, shop_id: 1, hot_cold: 0, caffeine: 1, menu_option: "Size:Regular_0/Large_300/Jumbo_500")

Menu.create(menu_title: "아이스 아메리카노", menu_price: 2800, shop_id: 1, hot_cold: 1, caffeine: 0, menu_option: "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500")
Menu.create(menu_title: "아이스 카페라떼", menu_price: 3400, shop_id: 1, hot_cold: 1, caffeine: 0, menu_option: "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500,우유:우유_0/저지방우유_0/두유_0")
Menu.create(menu_title: "아이스 카페모카", menu_price: 3700, shop_id: 1, hot_cold: 1, caffeine: 0, menu_option: "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500")
Menu.create(menu_title: "아이스 카푸치노", menu_price: 3700, shop_id: 1, hot_cold: 1, caffeine: 0, menu_option: "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500,우유:우유_0/저지방우유_0/두유_0")
Menu.create(menu_title: "아이스 카라멜마키아또", menu_price: 4000, shop_id: 1, hot_cold: 1, caffeine: 0, menu_option: "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500")
Menu.create(menu_title: "아이스 그린티라떼", menu_price: 3700, shop_id: 1, hot_cold: 1, caffeine: 1, menu_option: "Size:Regular_0/Large_300/Jumbo_500,우유:우유_0/저지방우유_0/두유_0")
Menu.create(menu_title: "아이스 고구마라떼", menu_price: 3700, shop_id: 1, hot_cold: 1, caffeine: 1, menu_option: "Size:Regular_0/Large_300/Jumbo_500,우유:우유_0/저지방우유_0/두유_0")
Menu.create(menu_title: "아이스 초코", menu_price: 3400, shop_id: 1, hot_cold: 1, caffeine: 1, menu_option: "Size:Regular_0/Large_300/Jumbo_500")
Menu.create(menu_title: "딸기 스무디", menu_price: 4000, shop_id: 1, hot_cold: 1, caffeine: 1, menu_option: "Size:Regular_0/Large_300/Jumbo_500")
Menu.create(menu_title: "복숭아 스무디", menu_price: 4000, shop_id: 1, hot_cold: 1, caffeine: 1, menu_option: "Size:Regular_0/Large_300/Jumbo_500")
