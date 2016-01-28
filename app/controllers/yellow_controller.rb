class YellowController < ApplicationController

	require 'pusher'
	
	def error_page
		
	end
	def login
	end

	def customer_data
		input = params[:login_input]
		selected_user = Kakaocustomer.where(:nick => input).first_or_create
		@selected_user = selected_user

		logger.info @selected_user.as_json

		@users_order = @selected_user.kakaoorders

		logger.info @users_order.to_json

		
	
	end

	def join_page
		headers = Hash[*env.select {|k,v| k.start_with? 'HTTP_'}
					.collect {|k,v| [k.sub(/^HTTP_/, ''), v]}
					.collect {|k,v| [k.split('_').collect(&:capitalize).join('-'), v]}
					.sort
					.flatten]
		logger.info headers
		txnid=""
		if !headers["Cookie"].nil?
		cookie = headers["Cookie"].split("; ")
		cookie.each do |one|
			one = one.split('=')
			logger.info one
			if one[0] == "txnId"
				txnid = one[1]
				logger.info txnid
			end
		end
		logger.info txnid
		end
		@kakao_nick = params[:id]
		@txnid = txnid
		selected_user = Kakaocustomer.where("nick=?",params[:id]).take
		if !selected_user.bday.nil?
			redirect_to "/yellow/error_page"
		end
		selected_user.txnid = txnid 
		
		selected_user.save
	end
	
	def join_and_tutorial
		#가입한 유저의 정보를 기존에 저장되어 있던 카카오톡 txnid를 통해서 호출하여 업데이트합니다
		#여기도 형식 검사해서 틀리면 집에 가라 시전 
		selected_user = Kakaocustomer.where("txnid=?",params[:txnid]).take
		selected_user.bday = params[:bday]
		selected_user.phone = params[:phone]
		selected_user.gender = params[:gender]
		selected_user.save
		#여기서는 튜토리얼 화면만 보여주면 됩니다. 템플릿 필요 렌더 니니요 
	end	


	def create_order
		new_order = Kakaoorder.new
		new_order.shop_id = Shop.where("shop_location=? and shop_name=?",params[:zone], params[:shop]).take.id
		new_order.kakaocustomer_id = params[:customer_id].to_i
		new_order.menu_id = Menu.where("shop_id=? and menu_title=?",new_order.shop_id, params[:menu]).take.id
		#new_order.option = 여기다가 custom 나눠서 담아야됨
		new_order.custom = params[:custom_option]
		new_order.price = params[:value].to_i
		new_order.order_time = Time.zone.now + params[:order_time].to_i*60
		new_order.payment_status = "before"
		new_order.save
		redirect_to :back
	end

	def call_kakaopay

		headers = Hash[*env.select {|k,v| k.start_with? 'HTTP_'}
					.collect {|k,v| [k.sub(/^HTTP_/, ''), v]}
					.collect {|k,v| [k.split('_').collect(&:capitalize).join('-'), v]}
					.sort
					.flatten]
		logger.info headers
		cookie = headers["Cookie"].split("; ")
		txnid = ""

		cookie.each do |one|
			one = one.split('=')
			logger.info one
			if one[0] == "txnId"
				txnid = one[1]
				logger.info txnid
			end
		end	
		selected_user = Kakaocustomer.where("txnid=?",txnid).take
		order_to_pay = selected_user.kakaoorders.where("payment_status=?","before").take
	    call_url = "http://bringit.kr:3000/hikakao.php?value=#{order_to_pay.price}&pname=#{Menu.find(order_to_pay.menu_id).menu_title}&txnid=#{selected_user.txnid}"
		redirect_to call_url
	end

	def adjust_txnid
		selected_user = Kakaocustomer.where("txnid=?",params[:old]).take
		selected_user.txnid = params[:txnid]
		selected_user.save
		render :json=>true 
	end

	def auto_complete
		input = params

		logger.info input

		return_json = {}
		return_json["success"] = "success"
		return_json["status_code"] = "200"
		#return_json["input"] = input

	    if input.has_key?("zone")
			shops_in_zone = Shop.where(:shop_location => input["zone"]).pluck("shop_name")
			logger.info shops_in_zone.to_json
			return_json["shop"] = shops_in_zone
		elsif input.has_key?("shop")
			selected_shop_id = Shop.find_by(:shop_name => input["shop"]).id
			menu_for_selected_shop = Menu.where(:shop_id => selected_shop_id)
			
			logger.info menu_for_selected_shop.to_json
			return_json["menu"] = menu_for_selected_shop.to_json
		end	

		render json: return_json
	end


	def send_message
		input = params

#		key_arr = input.keys
#		value_arr = input.values

#		key_arr.each do |key, index|
			# kakaocustomer 레코드 불러오기
#			chat_key = key.split(",")
#			chat_id = chat_key[0]
#			chat_name = chat_key[1]
#			chat_time = chat_key[2]
#			selected_user = Kakaocustomer.where(:chatid => chat_id).first_or_create
#			selected_user.update_attribute(:nick, chat_name)

			# value_arr에서 주문내역 추리기
#			message_arr = value_arr[index]

#			message_arr.each do |msg|
#				new_chatlog = Kakaochatlog.new
#				new_chatlog.chat_id = chat_id
#				new_chatlog.chat_name = nick
#				new_chatlog.message = msg
#				new_chatlog.message_time = DateTime.parse(chat_time)
#			end

			#reate_order 메소드 호출하기
#		end

		Pusher.url = "https://1e2e0a92d1f42ff0c0ae:b232bea32adb2d571081@api.pusherapp.com/apps/173648"

	    Pusher.trigger('message_channel', 'returned_message', {
			message: input.to_s
		})

			logger.info input.to_s
		render json: input
	end

end
