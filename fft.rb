#!/usr/bin/ruby

p1 = [1, 2]
p2 = [2, 3]

arr = [0, 1, 2, 3, 0, 0, 0, 0]

$omega = (0..arr.size * 2).inject({}){|h, k| h[k] = Complex(Math.cos(2 * Math::PI * k / arr.size), Math.sin(2 * Math::PI * k / arr.size)); h}
puts $omega.inspect
# puts $omega[2]

def fft(poly, power = 1)
	return poly if poly.size == 1
	evens = Array.new(poly.size / 2){|x| poly[x * 2]}
	odds = Array.new(poly.size / 2){|x| poly[x * 2 + 1]}
	evens = fft(evens, power * 2)
	odds = fft(odds, power * 2)
	evens.concat(evens)
	odds.concat(odds.map{|x| -x})
	# puts poly.size
	# puts "Odds: #{odds.inspect}\nEvens: #{evens.inspect}"
	temp=Array.new(poly.size){|i| evens[i] + odds[i] * $omega[i * power]}
	# puts "#{odds.inspect} : #{evens.inspect} : #{temp.inspect}"
	puts temp.inspect
	temp
end

puts fft(arr).inspect

