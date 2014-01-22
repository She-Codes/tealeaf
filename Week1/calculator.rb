require 'pry'
def say(msg)
  puts "=> #{msg}"
end

say "What's the first number?"
num1 = gets.chomp

say "What's the second number?"
num2 = gets.chomp

say "1) add 2) subtract 3) multiply 4) divide"
operator = gets.chomp

[1,2,3].each do |e|
  num2 = e
  count = e
end

puts "num2 is #{num2}"

if operator == '1'
  result = num1.to_i + num2.to_i
elsif operator == '2'
  result = num1.to_i - num2.to_i
elsif operator == '3'
  result = num1.to_i * num2.to_i
else 
  result = num1.to_f / num2.to_f
end

puts "Result is #{result}"