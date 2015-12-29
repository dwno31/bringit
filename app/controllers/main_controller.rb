class MainController < ApplicationController
  require 'rest-client'
  require 'uri'
  require 'net/http'
  require 'gcm'
  require 'eventmachine'
  def landing_page
	render :layout => false

  end

  def payco

	input = params

    input_order = Order.new  
    input_order.customer_id = Customer.where("customer_simid=?",input[:user_sim]).take.id
    input_order.shop_id = input[:cafe].to_i
    input_order.order_list = input[:order]
    input_order.order_time = Time.zone.parse(input[:pickup_time])
    input_order.check_active = true
    input_order.daily_number = "B"+(Order.where("order_time >=? and shop_id=?",Time.zone.now.beginning_of_day, input_order.shop_id).size+1).to_s
    input_order.is_inline = false
    order_numb = input_order.daily_number
    input_order.payment_method = input[:payment_method]
	shop_code = input_order.shop_id.to_s 

	input_json ={

		"sellerKey" => "3NVIIO",
		"sellerOrderReferenceKey" => Date.current.strftime("%Y%m%d").to_s + order_numb,
		"totalPaymentAmt" => eval(input_order.order_list)[0][:price],
		#"totalPaymentAmt" => "1",
		"serviceUrl" => "http://bringit.kr/main/cafe_status_check",
		#"serviceUrlParams" => params.to_json,
		"returnUrl" => "http://bringit.kr/main/order_success",
		"returnUrlParam" => params.to_json,
		"orderMethod" => "EASYPAY",
		"orderChannel"=> "MOBILE",
		"inAppYn"=>"Y",
		"customUrlSchemeUseYn"=> "n",
		"orderProducts" => [
			{
				"cpId" => "BRINGIT",
				"productId" => "BRINGIT_EASYP",
	            "productAmt"=> eval(input_order.order_list)[0][:price], 
				#"productAmt" => 1,
		        "productPaymentAmt"=> eval(input_order.order_list)[0][:price], 
				#"productPaymentAmt" => 1,
			    "sortOrdering"=> 1, 
				"productName"=> eval(input_order.order_list)[0][:name], 
	            "orderQuantity"=> eval(input_order.order_list)[0][:count], 
		        "sellerOrderProductReferenceKey"=> Date.current.strftime("%Y%m%d").to_s + order_numb #Time.strptime(Time.zone.today.to_s, "%Y%m%d").in_time_zone.to_s+order_numb 
			}
		],
		"extraData" => {"cancelMobileUrl" => "http://bringit.kr/main/order_cancel","viewOptions" => [{"showMobileTopGnbYn" => "n","iframeYn" => "n"}]}.to_json
	}

	response = RestClient.post 'https://api-bill.payco.com/outseller/order/reserve', input_json.to_json, :content_type => :json, :accept => :json
	
	logger.info response

	response_code = eval(response.body)[:code]

	if response_code == 1001 # parameter not correct
		input_json["sellerOrderReferenceKey"] << "_"
		input_json["orderProducts"][0]["sellerOrderProductReferenceKey"] << "_"
		response = RestClient.post 'https://api-bill.payco.com/outseller/order/reserve', input_json.to_json, :content_type => :json, :accept => :json
		logger.info response
	end
	#elsif response_code == 1012 # payment timeover
	#elsif response_code == 1402 # card limit
	#elsif response_code == 1450 || response_code == 1451 || response_code == 1452 || response_code == 1453 # temporal error
	#elsif response_code == 9000 # server down
		
	#else # ???
	#end
	render json: response    

	#redirect_to controller: "main", action: "order_success", input: input

  end

  def hello

	input_json ={ 
    "sellerKey"=> "S0FSJE", 
	#"sellerKey"=> "3NVIIO",
    "sellerOrderReferenceKey"=> "20151217-B7", 
    "totalPaymentAmt"=> "3400",  
    #"serviceUrl"=> "https://alpha-api-bill.payco.com/test/surl/ok",
	"serviceUrl"=> "http://bringit.kr/main/asdf",
    #"returnUrl"=> "http://demo-bill.payco.com:11111/result.nhn", 
	"returnUrl"=> "http://bringit.kr/main/order_success",
	"returnUrlParam"=> params.to_json,
	#"returnUrlParam" => "{\"returnUrlParam1\":\"data1\",\"returnUrlParam2\":300}",
#"&code=" + code + "&totalPaymentAmt=" + totalPaymentAmt +
#		"&reserveOrderNo=" + reserveOrderNo + "&paymentCertifyToken=" + paymentCertifyToken
	#"returnUrlParam" => "{\"sellerOrderReferenceKey\":\"TESTORDERKEY0000012\",\"totalPaymentAmt\":1000}",
    "orderMethod"=> "EASYPAY", 
	"orderChannel"=> "MOBILE",
	"inAppYn"=>"Y",
	"customUrlSchemeUseYn"=> "n",
    "orderProducts"=> [ 
        { 
            "cpId"=> "PARTNERTEST", 
			#"cpId"=> "BRINGIT",
            "productId"=> "PROD_EASY", 
			#"productId"=> "BRINGIT_EASYP",
            "productAmt"=> "3400", 
            "productPaymentAmt"=> "3400", 
            "sortOrdering"=> 1, 
            "productName"=> "고구마라떼", 
            "orderQuantity"=> 1, 
            "sellerOrderProductReferenceKey"=> "20151217-B7" 
        } 
    ],
	"extraData" => #[
		{
			"cancelMobileUrl" => "http://bringit.kr/asdf",
			"viewOptions" => [
				{
					"showMobileTopGnbYn" => "n",
					"iframeYn" => "n"
				}
			]	
		}.to_json
	#]
}
	
	response = RestClient.post 'https://alpha-api-bill.payco.com/outseller/order/reserve', input_json.to_json, :content_type => :json, :accept => :json
	#response = RestClient.post 'https://api-bill.payco.com/outseller/order/reserve', input_json.to_json, :content_type => :json, :accept => :json

	logger.info input_json
	logger.info response   
	logger.info response.body
	#temp = input_json.to_s +  response.to_s
    render json: response 
	#render json: temp
  
  end
 
  def cafe_status_check 

	logger.info params
	render json: "OK"

  end

  def order_cancel	
	render layout: false
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
    active_order = user_come.orders.where("check_active=? and order_time>=?",true, Date.today).take
    logger.info active_order
      
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
		elsif (active_order.order_time + 600 - DateTime.now)>0
		  active_order.check_active = false
          active_order.save
        end
        
        user_come.save
        logger.info receipt_page
        render json: [receipt_page, Shop.find(customer_shopid)] #영수증 정보를 넘겨주는것
      
      else
        user_come.save      
        render json: "" 
      end
    end
    
  end
  
  def default_order # default 값 불러오기
    
    user_sid = params[:user_sim]
    user_come = Customer.where("customer_simid=?",user_sid).take
    
    @default_order = user_come.orders.first
  
    if @default_order.nil? #오더가 없다
        
        render text: ""
    else  #첫 오더가 있으면
		@basic_order = JSON.parse(@default_order.to_json)
		@basic_order["order_time"] = DateTime.parse(@basic_order["order_time"]).strftime("%Y/%m/%d %H:%M")   
		@basic_order["cafe"] = @basic_order["shop_id"].to_i
        order_size = user_come.orders.where("shop_id=?",@basic_order["cafe"]).size 
		if order_size == 0
			@basic_order["coupon"] = -1
		else
			@basic_order["coupon"] = order_size%Shop.find(@basic_order["cafe"]).coupon
		end
        logger.info @basic_order
        render json: [@basic_order,Shop.find(@basic_order["shop_id"].to_i)]
    end
  end
    
  def cafelist #카페 선택 화�
	#shop 레코드에 지역도 추가.
	#지역마다 가져오는 것으로 수정.
	selected_user = Customer.where("customer_simid=?",params[:user_sim]).take
	shop_location = params[:shop_location]
	
	@shop = Shop.where("shop_location=?",shop_location).order(location_distant: :desc).as_json
	@shop.each{|shop|shop["remaining_cups"] = MainHelper.check_coupon(params[:user_sim],shop["id"])} 
logger.info @shop
    render json: @shop
    #카페 DB 필요함 
    #이름, 위치, 사진

  end

  
  def cafeinfo #카페 메뉴 화면
    cafe_id = params[:cafe_id] #클라이언트에서 선택한 카페의 id값을 받아온다
    hot_cold = params[:hot_cold].to_i
    @user_sim = params[:user_sim]
	@mod = params[:mod]
   	@sim_serial = params[:sim_serial]
	@shop_id = params[:shop_id].to_i
	
    #DB에서 해당 카페의 정보를 찾는다
    selected_cafe = Shop.find(cafe_id.to_i)
    logger.info selected_cafe
    @menulist = selected_cafe.menus.where("hot_cold=?",hot_cold).order(menu_order: :asc)
    # render json: menulist
  end


  def modify_daily
	input_json = eval(params[:order])[0]
	sim_serial = params[:sim_serial]
	shop_id = params[:shop_id].to_i
	selected_user = Customer.where("customer_simid=?",sim_serial).take
	
	#들어오는 order를 model에 맞추어 수정
	input = [{"name" => input_json[:name],
			  "price" => input_json[:price],
			  "count" => input_json[:count],
			  "options_list" => input_json[:options_list],
			  "long_option" => input_json[:long_option]
			}] 							
	logger.info selected_user
	daily_order = selected_user.orders.first	#해당 유저의 daily_order를 가져온다
	daily_order.shop_id = shop_id
	daily_order.order_list = input.to_s
	daily_order.save
		
	render json: ""
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
    input_order.shop_id =input[:cafe].to_i
    input_order.order_list = input[:order]
    input_order.order_time = Time.zone.parse(input[:pickup_time])
    input_order.check_active = true
    input_order.daily_number = "B"+(Order.where("order_time >=? and shop_id=?",Time.zone.now.beginning_of_day, input_order.shop_id).size+1).to_s
    input_order.is_inline = false
    order_numb = input_order.daily_number
    input_order.payment_method = input[:payment_method]
	shop_code = input_order.shop_id.to_s 
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
      order_convert[:option] = option_shot #두유나 샷추가는 그냥옵션에 담고
      order_convert[:custom] = option_milk + order[:long_option] #롱옵션은 커스텀에 담는다
      
      order_convert_list << order_convert #그리고 해당 해쉬값을 리스트에 담는다
    end
    logger.info order_convert_list
      push_order ={
        "menu" => order_convert_list,
        "pickup_time" => order_whole.order_time-Time.current.in_time_zone,
        "order_number" => order_whole.daily_number
      }
    
	logger.info push_order
	
	Pusher.trigger(shop_code,'new_order',push_order)
	#여기서 order_cast 대신에 provider id 등으로 바꿔서 채널     
    render_json = JSON.parse(input_order.to_json)
    render_json["order_time"] = DateTime.parse(render_json["order_time"]).strftime("%Y/%m/%d %H:%M")   
    render_json["cafe"] = render_json["shop_id"]
    logger.info render_json
	@render_json = render_json.as_json
	if params[:payment_method]=="kakaoPay"
		logger.info params[:payment_type]
		render json: render_json
	else
		render layout: false
	end
  end
  
  def get_push_alarm
	sim_serial = params[:user_sim]
	selected_user = Customer.where("customer_simid=?", sim_serial).take
	push_ag = selected_user.push_alarm

	render json: push_ag
  end

  def set_push_alarm	
	sim_serial = params[:user_sim]
	push_ag = params[:push_agreed]

	if push_ag=="true"
		@push_agreed = true
	else
		@push_agreed = false
	end

	selected_user = Customer.where("customer_simid=?",sim_serial).take
	
	# change attribute accordingly
	selected_user.push_alarm = @push_agreed
	selected_user.save

	render json: selected_user
  end 
end
