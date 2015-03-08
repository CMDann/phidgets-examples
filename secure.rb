#!/usr/bin/ruby

require 'rubygems'
require 'phidgets-ffi'

# Set to true if you want some extra output
debug = false

puts "Library Version: #{Phidgets::FFI.library_version}"

puts "Waiting for Phidgets..."

# Define the phidgets
rfid = Phidgets::RFID.new
adv = Phidgets::AdvancedServo.new

# Servo Functions

adv.on_attach  do |device, obj|
  
  puts "Servos Initilaized"

  # Set the servo to engaged
  device.advanced_servos[0].engaged = true

  #allow time for engaged to be set before event ends
  sleep 1
end

adv.on_detach  do |device, obj|
        puts "#{device.attributes.inspect} detached"
end

adv.on_error do |device, obj, code, description|
        puts "Error #{code}: #{description}"
end

# Additional Output if you like to see
if debug

	# Output the velocity change
	adv.on_velocity_change do |device, servo, velocity, obj|
    puts "Servo #{servo.index}'s velocity has changed to #{velocity}"
	end

	# Output the position change of the servo
	adv.on_position_change do |device, servo, position, obj|
	  puts "Servo #{servo.index}'s position has changed to #{position}"
	end

	# Output the current of the servo
	adv.on_current_change do |device, servo, current, obj|
    puts "Servo #{servo.index}'s current has changed to #{current}"
	end

end


# RFID functions
rfid.on_attach  do |device, obj|
	puts "RFID Actived"
  rfid.antenna = true
  rfid.led = true
  sleep 1
end

rfid.on_tag do |device, tag, obj|

  # Interact with the servo
  if tag == "4d004b113e"

  	puts "Authorized for #{tag}"

		3.times do
			max = adv.advanced_servos[0].position_max
	    adv.advanced_servos[0].position = rand(max)
	    sleep 0.5
	  end

  else

  	puts "Tag #{tag} unauthorized"

  end
  
end

rfid.on_tag_lost do |device, tag, obj|
  puts "Tag #{tag} removed"
end

# Waiting for the RFID
puts "Present ID tag....."

gets.chomp

# Closing the connection

puts 'DONE'

rfid.close

sleep 2

adv.advanced_servos[0].engaged = false

sleep 1

adv.close
