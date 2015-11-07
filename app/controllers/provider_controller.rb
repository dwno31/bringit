class ProviderController < ApplicationController
  # require 'gcm'
  
  
  def login
      
  
  
  end
  
  
  def view_order
    demo_order = {:order_number=>"B1", :name=>"그린티라떼", :pickup_time=>"2015.11.09 08:40", :cafe=>"브링잇카페", :option_list=>"Size:Regular/Add:2shot",:custom_option=>"두유"}
    
    @insert_order = demo_order
      
  
  end
  
  def inline_list
    goinline = params[:intoline_list]
    
    #파라미터에 있는 order값 + 날짜로 order테이블에서 레코드를 찾는다
    # goinline.each do |order_number|
    #   order_record = Order.where("order_number=? and date=?",order_number,DateTime.new.to_date).take
    # #해당 레코드의 status를 inline으로 바꾼다
    #   order_record.status = "inline"
    #   order_record.save
    # end
    
    render text: ""
    
  end
  
  def complete_list
    gocomplete = params[:complete_list]
    #파라미터에 있는 order값 + 날짜로 order테이블에서 레코드를 찾는다
    # gocomplete.each do |order_number|
    #   order_record = Order.where("order_number=? and date=?",order_number,DateTime.new.to_date).take
    # #해당 레코드의 status를 inline으로 바꾼다
    #   order_record.status = "complete"
    #   order_record.save
    # end
    
    #여기서 gcm 으로 해당 디바이스로 push 알람을 보내줘야함
    # gcm = GCM.new("AIzaSyAXelTBPvT_N9xyAtj5OqmnZuY_mhKeLIo")

    # #galaxy s4, galaxy camera 
    # registration_ids= ["dSE8I0Xow6s:APA91bEHlpJ4a9rWztbyWnLia8qqKV4wmoWpclcRKZJWLuzvsZsK-K2QSAiPOT0K1hZIxJn4fnISIt5inqLZCVYstoM0SBIghPe8KJoT9KIL_TXXtcFLLziK3Zfjx1CZrX68g0qT9O0l", "dzB_kXT-1AM:APA91bH83YlHSLdS73Y09DYWT9i2QcI2H58Y8rDLDGy5it_BRIlebi2pPVpr3593C2XJdCoXKUZspcqVfrq5WyCH17mO-mrPhKFxq9l7isy-OA2Vs9cBviZr1hQue09M_qdt7IOCBwPD"]
    # options = {data: {title: "브링잇", message: "졸리지만 커피는 마셔야죠!"}}
    # response = gcm.send_notification(registration_ids, options)
    # puts response
    
    render text: ""
     
  end
  
  
  
end
