#!/usr/bin/ruby

p1 = Array.new(ARGV.first.to_i){rand()}
p2 = Array.new(ARGV.first.to_i){rand()}

$omega = (0..p1.size * 4).inject({}){|h, k| h[k] = Complex(Math.cos(2 * Math::PI * k / (p1.size * 2)), Math.sin(2 * Math::PI * k / (p1.size * 2))); h}
$invOmega = (0..p1.size * 4).inject({}){|h, k| h[k] = Complex(Math.cos(2 * Math::PI * k / (p1.size * 2)), -Math.sin(2 * Math::PI * k / (p1.size * 2))); h}
$bitShuffle = Array.new(p1.size * 2){|x| x.to_s(2).rjust(Math.log2(p1.size * 2), '0').reverse.to_i(2)}

def recursiveFFT(poly, inv = false, power = 1)
	return poly if poly.size == 1
	evens = recursiveFFT(Array.new(poly.size / 2){|x| poly[x * 2]}, inv, power * 2)
	odds = recursiveFFT(Array.new(poly.size / 2){|x| poly[x * 2 + 1]}, inv, power * 2)
	evens.concat(evens)
	odds.concat(odds)
	Array.new(poly.size){|i| evens[i] + odds[i] * (inv ? $invOmega[i * power] : $omega[i * power])}
end

def dynamicFFT(poly, inv = false)
	logN = Math.log2(poly.size)
	sol = Array.new(2){Array.new(poly.size)}
	(0...poly.size).each{|x| sol[0][$bitShuffle[x]] = poly[x]}
	size = 2
	power = poly.size / 2
	(1..logN).each{|i|
		(0...poly.size).step(size).each{|j|
			(0...size / 2).each{|k|
				odd = sol[(i - 1) % 2][j + k + size / 2] * (inv ? $invOmega[k * power] : $omega[k * power])
				sol[i % 2][j + k] = sol[(i - 1) % 2][j + k] + odd;
				sol[i % 2][j + k + size / 2] = sol[(i - 1) % 2][j + k] - odd
			}
		}
		power /= 2
		size *= 2
	}
	sol[logN % 2]
end

p1.concat(Array.new(p1.size, 0))
p2.concat(Array.new(p2.size, 0))

start = Time.now
recursiveFFT(recursiveFFT(p1).zip(recursiveFFT(p2)).map{|x| x.inject(:*)}, true).map{|x| x / p1.size}.map(&:real).inspect
puts "#{ARGV.first} Recursive: #{Time.now - start} seconds"

start = Time.now
dynamicFFT(dynamicFFT(p1).zip(dynamicFFT(p2)).map{|x| x.inject(:*)}, true).map{|x| x / p1.size}.map(&:real).inspect
puts "#{ARGV.first} Dynamic: #{Time.now - start} seconds"
