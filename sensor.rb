#!/usr/bin/ruby

require 'rubygems'
require 'phidgets-ffi'

# Set to true if you want some extra output
debug = false

puts "Library Version: #{Phidgets::FFI.library_version}"

ifkit = Phidgets::InterfaceKit.new
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

# Interface kit functions
ifkit.on_attach  do |device, obj|

	if debug
		puts "Device attributes: #{device.attributes} attached"
	  puts "Class: #{device.device_class}"
		puts "Id: #{device.id}"
		puts "Serial number: #{device.serial_number}"
		puts "Version: #{device.version}"
		puts "# Digital inputs: #{device.inputs.size}"
		puts "# Digital outputs: #{device.outputs.size}"
		puts "# Analog inputs: #{device.sensors.size}"
	end
  

	sleep 1

	if(device.sensors.size > 0)
    device.ratiometric = false
		device.sensors[0].data_rate = 64
    device.sensors[0].sensitivity = 15

    if debug
    	puts "Sensivity: #{device.sensors[0].sensitivity}"
	    puts "Data rate: #{device.sensors[0].data_rate}"
	    puts "Data rate max: #{device.sensors[0].data_rate_max}"
	    puts "Data rate min: #{device.sensors[0].data_rate_min}"
	    puts "Sensor value[0]: #{device.sensors[0].to_i}"
	    puts "Raw sensor value[0]: #{device.sensors[0].raw_value}"
    end

    device.outputs[0].state = true
    sleep 1 #allow time for digital output 0's state to be set
    puts "Is digital output 0's state on? ... #{device.outputs[0].on?}"
	end
end

if debug
	ifkit.on_detach  do |device, obj|
    puts "#{device.attributes.inspect} detached"
	end

	ifkit.on_error do |device, obj, code, description|
	    puts "Error #{code}: #{description}"
	end

	ifkit.on_input_change do |device, input, state, obj|
	    puts "Input #{input.index}'s state has changed to #{state}"
	end

	ifkit.on_output_change do |device, output, state, obj|
	    puts "Output #{output.index}'s state has changed to #{state}"
	end
end

ifkit.on_sensor_change do |device, input, value, obj|

	position = value / 10

	max = adv.advanced_servos[0].position_max

	puts "Sensor #{input.index}'s value has changed to #{value}, Position: #{position}"

	if position < max 

		adv.advanced_servos[0].position = position

	end

end

sleep 10

# Closing the connection

puts 'DONE'

gets.chomp

# Closing the connection

puts 'DONE'

ifkit.close

adv.advanced_servos[0].engaged = false

sleep 1

adv.close
