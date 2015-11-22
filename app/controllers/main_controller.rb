class MainController < ApplicationController
  require 'gcm'
  require 'eventmachine'
  
  def landing_page
	render :layout => false

  end
  def hello
    
    demo_hash = [{"name" =>"아메리카노", "count" => "1", "price" => "1500", "type" =>0, "hot_cold"=>0,"options_list" => "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500" },{ "name" =>"아이스 아메리카노", "count" => "1", "price" => "1800", "type" => 0, "hot_cold"=> 1,"options_list" => "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500" },{ "name" =>"카페라떼", "count" => "1", "price" => "1800","hot_cold"=> 0, "type"=> 0,  "options_list" => "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500,우유:우유_0/저지방우유_0/두유_0" },{"name" =>"아이스 카페라떼", "count" => "1", "price" => "2000", "type" => 0, "hot_cold"=> 1,"options_list" => "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500,우유:우유_0/저지방우유_0/두유_0" }, { "name" =>"카페모카", "count" => "1", "price" => "1800", "hot_cold"=> 0, "type"=> 0, "options_list" => "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500" }, { "name" =>"아이스 카페모카", "count" => "1", "price" => "2000", "type" => 0, "hot_cold"=> 1, "options_list" => "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500" }, { "name" =>"그린티라뗴", "count" => "1", "price" => "1500", "hot_cold"=>1, "type"=>1, "options_list" => "Size:Regular_0/Large_300/Jumbo_500,우유:우유_0/저지방우유_0/두유_0" },{ "name" =>"딸기스무디", "count" => "1", "price" => "2000","hot_cold"=> 1, "type"=> 1,  "options_list" => "Size:Regular_0/Large_300/Jumbo_500" },]
      
    render json: demo_hash
  
  end
  
  
  def user_demo
    # income_user = Customer.where("customer_simid=?",params[:user_sim]).take
    default_order = Order.find(4)
    
    render_default = { 
    "cafe" => Shop.find(default_order.shop_id).shop_name,
    "order_list" => default_order.order_list,
    "order_time" => default_order.order_time,
    "daily_number" => default_order.daily_number,
    "has_pickedup" => default_order.check_active,
    "payment_method" => default_order.payment_method,
    "check_active" => default_order.check_active
    }
    render json: render_default
  end
    
  def index #과거 주문 이력 조회

    user_sid = params[:user_sim]  #유저의 심정보를 받아옵니다
    user_come = Customer.find_or_create_by(customer_simid: user_sid)
    user_come.gcmid = params[:gcm_id]
    
    @default_order = user_come.orders.first
    active_order = user_come.orders.where("check_active=?",true).take
    
    
    if @default_order.nil? #오더가 없다
        user_come.save
        render text: ""
    else  #첫 오더가 있으면
      if !active_order.nil?  #액티브 된게 있어
        receipt_page = active_order.to_json
        
        customer_shopid = active_order.shop_id
        receipt_page = JSON.parse(receipt_page) 
        receipt_page["cafe"] = Shop.find(customer_shopid).shop_name
        receipt_page["order_time"] = DateTime.parse(receipt_page["order_time"]).strftime("%Y/%m/%d %H:%M")
       
        if active_order.is_inline.nil?
          active_order.check_active = false
          active_order.save
        end
        
        user_come.save
        logger.info receipt_page
        render json: receipt_page #영수증 정보를 넘겨주는것
      
      else #오더가 있는데 액티브가 없어
        
        @basic_order = JSON.parse(@default_order.to_json)
        @basic_order["order_time"] = DateTime.parse(@basic_order["order_time"]).strftime("%Y/%m/%d %H:%M")   
        @basic_order["cafe"]=Shop.find(@basic_order["shop_id"]).shop_name        
        user_come.save      
        render json: @basic_order
      end
    end
    
  end
  
  def default_order # default 값 불러오기
    
    user_sid = params[:user_sim]
    user_come = Customer.find_by(customer_simid: user_sid)
    
    @default_order = user_come.orders.first
    @basic_order = JSON.parse(@default_order.to_json)
    @basic_order["order_time"] = DateTime.parse(@basic_order["order_time"]).strftime("%Y/%m/%d %H:%M")   
    @basic_order["cafe"] = Shop.find(@basic_order["shop_id"]).shop_name
   
    if @default_order.nil? #오더가 없다
        user_come.save
        render text: ""
    else  #첫 오더가 있으면
        user_come.save
        logger.info @basic_order
        render json: @basic_order
    end
  end
  
  def cafelist #카페 선택 화면
    @shop = Shop.all
    
    render json: @shop
    #카페 DB 필요함 
    #이름, 위치, 사진

  end

  
  def cafeinfo #카페 메뉴 화면
    cafe_id = params[:cafe_id] #클라이언트에서 선택한 카페의 id값을 받아온다
    hot_cold = params[:hot_cold].to_i
    @user_sim = params[:user_sim]
    
    #DB에서 해당 카페의 정보를 찾는다
    selected_cafe = Shop.find(cafe_id.to_i)
    logger.info selected_cafe
    @menulist = selected_cafe.menus.where("hot_cold=?",hot_cold)
    # render json: menulist
  end
  
  def order_success #주문을 받아서 결제를 확인하고,  카페측으로 보내줍니다
      #해당 주문의 내용을 카페측으로 보내고, 주문을 active로 만듭니다
    input = params    
    
    # demo_user = { 
    # "order" => menu, 옵션, 잔수
        # "menu" => "아이스아메리카노",
        # "option" => "연하게", //여기다 나머지 
        # "size" => "tall",
    # "pickup_time" => Time.zone.parse("2015. 11. 04. 02:25")-Time.current.in_time_zone,
    # "order_number" => "B1"
    # 
    # 
    # }
    
    
    input_order = Order.new  
    input_order.customer_id = Customer.where("customer_simid=?",input[:user_sim]).take.id
    input_order.shop_id = Shop.where("shop_name=?",input[:cafe]).take.id
    input_order.order_list = input[:order]
    input_order.order_time = Time.zone.parse(input[:pickup_time])
    input_order.check_active = true
    input_order.daily_number = "B"+(Order.where("order_time >=? and shop_id=?",Time.zone.now.beginning_of_day, input_order.shop_id).size+1).to_s
    input_order.is_inline = false
    order_numb = input_order.daily_number
    input_order.payment_method = input[:payment_method]
    input_order.save
    
    #주문이 success하게되면, 해당 주문을 카페쪽 웹앱 클라이언트로 push해준다
    
    
    order_whole = Order.where("order_time>=? and daily_number=?",Time.zone.now.beginning_of_day,order_numb).take
    logger.info order_whole.to_json
    orderlist = eval(order_whole.order_list)
    order_convert_list = [] #convert된 order들을 담는 배열
    order_convert = {} #해쉬 데이터 선언
    
    orderlist.each do |order| 
    #오더배열을 each로 돌려서 order에는 1개의 order값 들어온다 적당하게 바꿔서 카페로 보내주는 형식으로 바꾼다
      order_convert = {} #각각의 order들을 담는다
      logger.info order
      order_convert[:menu] = order[:name]  #메뉴이름 하나 담고
      order_convert[:count] = order[:count]#갯수 담고
      
      push_option = order[:options_list]  #옵션리스트 쫙 써있는거 분리한다
      option_size = ""
      option_milk = ""
      option_shot = ""
      logger.info push_option;
      logger.info "옵션나누기전"
      push_option = push_option.split(',')
      
      push_option.each do |option|
        
        option_block = option.split(':')
        case option_block[0]
        
        when "Size"
          option_size = option_block[1]
        when "우유"
          option_milk = option_block[1]
        when "샷  추가"
          option_shot = option_block[1]
          if option_shot == "None"
            option_shot = "None"
          end
        when "샷 추가"
          option_shot = option_block[1]
          if option_shot == "None"
            option_shot = "None"
          end
        end
      end  
      
      order_convert[:size] = option_size #사이즈도 담고
      order_convert[:option] = option_shot+option_milk #두유나 샷추가는 그냥옵션에 담고
      order_convert[:custom] = order[:long_option] #롱옵션은 커스텀에 담는다
      
      order_convert_list << order_convert #그리고 해당 해쉬값을 리스트에 담는다
    end
    logger.info order_convert_list
      push_order ={
        "menu" => order_convert_list,
        "pickup_time" => order_whole.order_time-Time.current.in_time_zone,
        "order_number" => order_whole.daily_number
      }
    
    EM.run {
      client = Faye::Client.new('http://bringit.kr:9292/faye')
      client.publish('/foo', push_order)
    }
    
    
    render_json = JSON.parse(input_order.to_json)
    render_json["order_time"] = DateTime.parse(render_json["order_time"]).strftime("%Y/%m/%d %H:%M")   
    render_json["cafe"] = Shop.find(render_json["shop_id"]).shop_name
    logger.info render_json
    logger.info "주문받은거"
    render json: render_json
  end
  
  def add_order
    input_user = Customer.where("customer_simid=?",params[:user_sim]).take  
    # input_user = Customer.find(2)
    input_menu = Menu.find(params[:id].to_i)
    input_price = input_menu.menu_price
    
    push_orderline = {
      'menu_title' => input_menu.menu_title,
      'count' => params[:count].to_i,
      'hot_cold' => input_menu.hot_cold,
      'menu_price' => input_price,
      'menu_option' => ("샷 추가:"+params[:shot]+",Size:"+params[:size]),
      'long_option' => params[:long_option]
    }
    logger.info push_orderline
    
    gcm = GCM.new("AIzaSyAXelTBPvT_N9xyAtj5OqmnZuY_mhKeLIo")
    registration_ids = [input_user.gcmid]  
    options = {data: {title: "order", message: push_orderline}}
    response = gcm.send_notification(registration_ids, options)
    puts response
    
    render json: {}
    
  end
  
  
  
end
