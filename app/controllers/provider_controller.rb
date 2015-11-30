class ProviderController < ApplicationController
  require 'gcm'
  
  def login
    
  end
  
  def login_check
    input_shopnu = params[:shopid]
    input_shopid = params[:shoppass]
    
    login_shop = Shop.where("cafe_phone=? and shop_loginid=?",input_shopnu,input_shopid).take
    
    if login_shop.nil?
      redirect_to '/provider/login'
    else
      session[:shop_id] = login_shop.id
      redirect_to '/provider/view_order'
    end
    
  end
  
#   {"order":"[{\"name\":\"아이스 카페라떼\",\"count\":1,\"price\":4000,\"options_list\":\"샷 추가:None,Size:Regular\",\"long_option\":\"\"},{\"name\":\"아이스 카페라떼\",\"count\":1,\"price\":4000,\"options_list\":\"샷 추가:None,Size:Regular\",\"long_option\":\"\"},{\"name\":\"아이스 카페라떼\",\"count\":1,\"price\":4000,\"options_list\":\"샷 추가:None,Size:Regular\",\"long_option\":\"\"},{\"name\":\"아이스 카페라떼\",\"count\":1,\"price\":4000,\"options_list\":\"샷 추가:None,Size:Regular\",\"long_option\":\"\"}]", "order_number":"", "pickup_time":"2015.11.14 22:09", "payment_method":"kakaoPay", "has_pickedup":"false", "cafe":"뉴기니 버드", "user_sim":"8982301014000387835" }
  
  def view_order
    shop_id = session[:shop_id].to_i
    logger.info shop_id
    if shop_id == 0
      redirect_to '/provider/login'
    end
    @beforeline_order = []
    push_order = {}
    Order.where("shop_id=? and order_time>=? and is_inline=?",shop_id,Time.current.in_time_zone.beginning_of_day,false).each do |order_whole|
    
    orderlist = eval(order_whole.order_list)
    order_convert_list = [] #convert된 order들을 담는 배열
    order_convert = {} #해쉬 데이터 선언
    
      orderlist.each do |order| 
      #오더배열을 each로 돌려서 order에는 1개의 order값 들어온다 적당하게 바꿔서 카페로 보내주는 형식으로 바꾼다
        order_convert = {} #각각의 order들을 담는다
        
        order_convert[:menu] = order[:name]  #메뉴이름 하나 담고
        order_convert[:count] = order[:count]#갯수 담고
        
        push_option = order[:options_list]  #옵션리스트 쫙 써있는거 분리한다
        option_size = ""
        option_milk = ""
        option_shot = ""
        
        push_option = push_option.split(',')
        
        push_option.each do |option|
          
          option_block = option.split(':')
          case option_block[0]
          
          when "Size"
            option_size = option_block[1]
          when "우유"
            option_milk = option_block[1]
          when "샷 추가"
            option_shot = option_block[1]
          end
          
        end  
        
        order_convert[:size] = option_size #사이즈도 담고
        order_convert[:option] = option_shot+option_milk #두유나 샷추가는 그냥옵션에 담고
        order_convert[:custom] = order[:long_option] #롱옵션은 커스텀에 담는다
        
        order_convert_list << order_convert #그리고 해당 해쉬값을 리스트에 담는다
      
        push_order ={
          :menu => order_convert_list,
          :pickup_time => order_whole.order_time-Time.current.in_time_zone,
          :order_number => order_whole.daily_number
        }
        
        
        
      end
      @beforeline_order << push_order
      
    end #beforeline each문 끝
    
    @inline_order = []
    push_inline = {}
    Order.where("shop_id=? and order_time>=? and is_inline=?",shop_id,Time.current.in_time_zone.beginning_of_day,true).each do |order_whole|
    
    orderlist = eval(order_whole.order_list)
    order_convert_list = [] #convert된 order들을 담는 배열
    order_convert = {} #해쉬 데이터 선언
    
      orderlist.each do |order| 
      #오더배열을 each로 돌려서 order에는 1개의 order값 들어온다 적당하게 바꿔서 카페로 보내주는 형식으로 바꾼다
        order_convert = {} #각각의 order들을 담는다
        
        order_convert[:menu] = order[:name]  #메뉴이름 하나 담고
        order_convert[:count] = order[:count]#갯수 담고
        
        push_option = order[:options_list]  #옵션리스트 쫙 써있는거 분리한다
        option_size = ""
        option_milk = ""
        option_shot = ""
        
        push_option = push_option.split(',')
        
        push_option.each do |option|
          
          option_block = option.split(':')
          case option_block[0]
          
          when "Size"
            option_size = option_block[1]
          when "우유"
            option_milk = option_block[1]
          when "샷 추가"
            option_shot = option_block[1]
          end
          logger.info option_block[0]
        end  
        
        order_convert[:size] = option_size #사이즈도 담고
        order_convert[:option] = option_shot+option_milk+order[:long_option] #두유나 샷추가는 그냥옵션에 담고
        order_convert[:custom] = order[:long_option] #롱옵션은 커스텀에 담는다
        
        order_convert_list << order_convert #그리고 해당 해쉬값을 리스트에 담는다
      
        push_inline ={
          :menu => order_convert_list,
          :pickup_time => order_whole.order_time-Time.current.in_time_zone,
          :order_number => order_whole.daily_number
        }
        
        
      end
      
      @inline_order << push_inline
        
    end #inline each문 끝
     
    
    
  
  end #메소드 끝
  
  def inline_list
    goinline = params[:intoline_list]
    number_list = []
    #파라미터에 있는 order값 + 날짜로 order테이블에서 레코드를 찾는다
    goinline.each do |whole_number|
      number_list << whole_number.gsub(/order_/,'')
    end
    
    number_list.each do |order_number|
      order_record = Order.where("daily_number=? and order_time>=?",order_number,Time.zone.now.beginning_of_day).take
    #해당 레코드의 status를 inline으로 바꾼다
      order_record.is_inline = true
      order_record.save
    end
    
    render text: ""
    
  end
  
  def complete_list
    goinline = params[:complete_list]
    number_list = []
    gcm = GCM.new("AIzaSyAXelTBPvT_N9xyAtj5OqmnZuY_mhKeLIo")
    #파라미터에 있는 order값 + 날짜로 order테이블에서 레코드를 찾는다
    goinline.each do |whole_number|
      number_list << whole_number.gsub(/order_/,'')
    end
    
    number_list.each do |order_number|
      order_record = Order.where("daily_number=? and order_time>=?",order_number,Time.zone.now.beginning_of_day).take
    #해당 레코드의 status를 inline으로 바꾼다
      order_record.is_inline = nil
      
    
    #해당 레코드의 주인의 Customer를 호출해서 gcmid를 받아와서 push를 보낸다  
    logger.info order_record.customer_id
    registration_ids = [Customer.find(order_record.customer_id).gcmid]  
    logger.info registration_ids
    options = {data: {title: "브링잇", message: "주문하신 음료가 나왔어요!"}}
    response = gcm.send_notification(registration_ids, options)
    puts response
    order_record.save
    end
    
    
    
    render text: ""
     
  end
  
  def admin_page
	@orders = Order.all
	
			


  end  

  def order_test
    
  end
  
  
end
