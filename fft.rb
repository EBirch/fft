#!/usr/bin/ruby

p1 = [0, 1, 2, 3]
p2 = [10, 11, 12, 13]

$omega = (0..p1.size * 4).inject({}){|h, k| h[k] = Complex(Math.cos(2 * Math::PI * k / (p1.size * 2)), Math.sin(2 * Math::PI * k / (p1.size * 2))); h}
$invOmega = (0..p1.size * 4).inject({}){|h, k| h[k] = Complex(Math.cos(2 * Math::PI * k / (p1.size * 2)), -Math.sin(2 * Math::PI * k / (p1.size * 2))); h}

def fft(poly, inv = false, power = 1)
	return poly if poly.size == 1
	evens = fft(Array.new(poly.size / 2){|x| poly[x * 2]}, inv, power * 2)
	odds = fft(Array.new(poly.size / 2){|x| poly[x * 2 + 1]}, inv, power * 2)
	evens.concat(evens)
	odds.concat(odds)
	Array.new(poly.size){|i| evens[i] + odds[i] * (inv ? $invOmega[i * power] : $omega[i * power])}
end

p1.concat(Array.new(p1.size, 0))
p2.concat(Array.new(p2.size, 0))
p1fft = fft(p1)
p2fft = fft(p2)
puts fft(p1fft.zip(p2fft).map{|x| x.inject(:*)}, true).map{|x| x / p1.size}.map(&:real).inspect
