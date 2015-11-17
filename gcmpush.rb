require 'gcm'
    gcm = GCM.new("AIzaSyAXelTBPvT_N9xyAtj5OqmnZuY_mhKeLIo")
    registration_ids = ["emwYa6NpZ40:APA91bEW0xXdYgeLq_AlCrFyEcPC4lSjFkB1VYyGLBjXWmEQYMttgPjtVGioRx_E2T8_Rw8lgpHxKoB8AmnBU6Srv8h_W4rxTQzM6kDSJeVSygSwl1nFwvOVtoiG0QHpqO9uPVkO_utw"]  
hello = {"menu_title"=>"카라멜마키아또", "count"=>2,"menu_price"=>3700, "menu_option"=>"샷 추가:None,Size:Regular", "long_option"=>"ㄱ디"}
    options = {data: {title: "order", message:hello}}

    response = gcm.send_notification(registration_ids, options)
    puts response
    
