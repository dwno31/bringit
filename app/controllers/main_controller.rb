class MainController < ApplicationController
  require 'eventmachine'
  
  def hello
    
    demo_hash = [{"name" =>"아메리카노", "count" => "1", "price" => "1500", "type" =>0, "hot_cold"=>0,"options_list" => "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500" },{ "name" =>"아이스 아메리카노", "count" => "1", "price" => "1800", "type" => 0, "hot_cold"=> 1,"options_list" => "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500" },{ "name" =>"카페라떼", "count" => "1", "price" => "1800","hot_cold"=> 0, "type"=> 0,  "options_list" => "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500,우유:우유_0/저지방우유_0/두유_0" },{"name" =>"아이스 카페라떼", "count" => "1", "price" => "2000", "type" => 0, "hot_cold"=> 1,"options_list" => "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500,우유:우유_0/저지방우유_0/두유_0" }, { "name" =>"카페모카", "count" => "1", "price" => "1800", "hot_cold"=> 0, "type"=> 0, "options_list" => "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500" }, { "name" =>"아이스 카페모카", "count" => "1", "price" => "2000", "type" => 0, "hot_cold"=> 1, "options_list" => "샷 추가:None_0/1샷 추가_300/2샷 추가_600,Size:Regular_0/Large_300/Jumbo_500" }, { "name" =>"그린티라뗴", "count" => "1", "price" => "1500", "hot_cold"=>1, "type"=>1, "options_list" => "Size:Regular_0/Large_300/Jumbo_500,우유:우유_0/저지방우유_0/두유_0" },{ "name" =>"딸기스무디", "count" => "1", "price" => "2000","hot_cold"=> 1, "type"=> 1,  "options_list" => "Size:Regular_0/Large_300/Jumbo_500" },]
      
    render json: demo_hash
  
  end
  
  def user_demo

    demo_order = [{'name' => '아메리카노', 'count' => '1','price' => '1500', "long_option" => "", 'options_list' => '샷 추가:None,Size:Regular'},{'name' => '망고 스무디', 'count' => '1','price' => '2500', "long_option" => "", 'options_list' => 'Size:Regular'}]
    # demo_order = {'name' => '아메리카노', 'count' => '1','price' => '1500', 'options_list' => 'Size:Regular'}
    demo_user = { 
    "cafe" => "뉴기니 버드",
    "order" => demo_order,
    "pickup_time" => "2015. 10. 28. 08:40",
    "order_number" => "B1",
    "has_pickedup" => "false",
    "payment_method" => "kakaoPay"
    }
    render json: demo_user
  end
    
  def index #과거 주문 이력 조회

    user_sid = params[:user_sim]  #유저의 심정보를 받아옵니다
    user_come = Customer.find_or_create_by(customer_simid: user_sid)
    @default_order = user_come.orders.first
    
    if @default_order.nil?
        render json: @default_order
    else
      if !user_come.orders.where("check_active=?",true).empty? # check_active 칼럼 만들어야됨 //아직 없음 tf로
        # active된 order를 넘겨주면 됨
        render json: user_come.orders.where("check_active=?",true).take #영수증 정보를 넘겨주는것
      end
      
      render json: @default_order
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
    #DB에서 해당 카페의 정보를 찾는다
    selected_cafe = Shop.find(cafe_id.to_i)
    logger.info selected_cafe
    menulist = selected_cafe.menus
    render json: menulist
  end

  def order_comfirm #시간 선택 및 메뉴확인
      #주문 Table의 Record를 만들고 User의 카드key값을 PG사로 전송합니다
  end

  def order_success #pg 사로부터 결제 결과 확인
      #해당 주문의 내용을 카페측으로 보내고, 주문을 active로 만듭니다
    input = params    
    
    # demo_user = { 
    # "menu" => "아이스아메리카노",
    # "pickup_time" => Time.zone.parse("2015. 11. 04. 02:25")-Time.current.in_time_zone,
    # "order_number" => "B1",
    # "size" => "tall",
    # "option" => "연하게"
    # }
    
    #같은 shop-date인 order를 check 해서 그 갯수 +1로 daily_number를 더해서 레코드를 생성한다
    
    #주문이 success하게되면, 해당 주문을 카페쪽 웹앱 클라이언트로 push해준다
    EM.run {
      client = Faye::Client.new('http://bringit.kr:9292/faye')
      client.publish('/foo', input)
    }
    render json: input
  end
  
  
end
