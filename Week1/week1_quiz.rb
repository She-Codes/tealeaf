# 1. What is the value of a after the below code is executed?
a = 1
b = a
b = 3

# a = 1

# 2. What's the difference between an Array and a Hash?
# An array has a numbered index of items while a hash can hash can be in any order and can have different objects
# for the key.

# 3. Every Ruby expression returns a value. Say what value is returned in the below expressions:
array = [1, 2, 3, 3] # [1, 2, 3, 3]
[1, 2, 3, 3].uniq # [1, 2, 3]
[1, 2, 3, 3].uniq! # [1, 2, 3]

# 4.  map returns the result of the code block and select returns an element based on whether the code block
#     is true so a boolean
[5, 4, 3].map {|e| e!}
[5, 4, 3].select {|e| e > 4}

# 5. Say you wanted to create a Hash.  How would you do so if you wanted the hash keys to be string objects instead of symbols?
new_hash = {"a" => 4, "b" => 5}

# 6. What is returned?
x = 1
x.odd? ? "no way!" : "yes, sir!" 
# "no way!"

# 7. What is x?
x = 1
  3.times do
    x += 1
  end
  puts x
# x == 4

# 8. What is x?
3.times do
  x += 1
end
puts x
# nil

# My question

x = 4

arr = [5, 6, 7]

arr.each do |x|
  x + 5
end

