class MainController < ApplicationController
  
  
  def hello
    demo_hash = [{"name" =>"아메리카노", "count" => "1", "price" => "1500", "type" =>0, "hot_cold"=>0,  "options_list" => "Size:Regular_0/Large_300/Jumbo_500" },{"name" =>"그린티라뗴", "count" => "1", "price" => "1500","hot_cold"=>1, "type"=>1,  "options_list" => "Size:Regular_0/Large_300/Jumbo_500" }]
    render json: demo_hash
  
  end
  
  def user_demo
    # Rails.logger.info 
    # Rails.logger.info request.env
    # demo_order = [{'name' => '아메리카노', 'count' => '1','price' => '1500', 'options_list' => 'Size:Regular'},{'name' => '망고 스무디', 'count' => '1','price' => '2500', 'options_list' => 'Size:Regular'}]
    demo_order = {'name' => '아메리카노', 'count' => '1','price' => '1500', 'options_list' => 'Size:Regular'}
    demo_user = { 
   "cafe" => "브링잇카페",
   "order" => demo_order,
    "pickup_time" => "2015. 10. 28. 08:40",
    "order_number" => "B1",
    "has_pickedup" => "false"
    }
    render json: demo_user
  end
    
  def index #과거 주문 이력 조회

    user_sid = params[:sid]  #유저의 심정보를 받아옵니다
    #DB에서 심정보를 조회해서 현재 active 되어있는지 확인하는 코드 삽입
    #if 문을 통해서 active시 영수증 페이지를 보여준다
    #주문 active 여부와 default 값을 DB에서 찾아서 클라이언트로 리턴해줍니다
    #주문// active 일시 true, 아닐시 false를 return한다

  end
  
  def cafelist #카페 선택 화면
    
    #카페 DB 필요함 
    #이름, 위치, 사진

  end


  def cafeinfo #카페 메뉴 화면
    cafe_id = params[:cafe_id] #클라이언트에서 선택한 카페의 id값을 받아온다
    #DB에서 해당 카페의 정보를 찾는다
    #cafeinfo.html.erb에 카드 프레임을 짜놓고 해당 카페의 정보를 뿌린다
    @menulist = Menu.where("shop_id=?",1)

  end

  def order_comfirm #시간 선택 및 메뉴확인
      #주문 Table의 Record를 만들고 User의 카드key값을 PG사로 전송합니다
  end

  def order_success #pg 사로부터 결제 결과 확인
      #해당 주문의 내용을 카페측으로 보내고, 주문을 active로 만듭니다
    input = params
    
    logger.info input
    
    
    input[:order_number] = "B1_checked"
    
    logger.info input
    
    render json: input
  end
  
  
end
