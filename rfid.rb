require 'rubygems'
require 'phidgets-ffi'
 
puts "Library Version: #{Phidgets::FFI.library_version}"
 
rfid = Phidgets::RFID.new
 
puts "Waiting for PhidgetRFID to attached..."
 
rfid.on_attach  do |device, obj|
  rfid.antenna = true
  rfid.led = true
  sleep 1
end
 
rfid.on_tag do |device, tag, obj|
  puts "Tag #{tag} detected"
end
 
rfid.on_tag_lost do |device, tag, obj|
  puts "Tag #{tag} removed"
end
 
puts "Present ID tag....."
 
gets.chomp
 
puts 'DONE'
 
rfid.close
