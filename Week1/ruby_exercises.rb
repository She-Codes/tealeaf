#1. Use the "each" method of Array to iterate over [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], and print out each value.
a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
a.each {|x| print x}

#2. Same as above, but only print out values greater than 5.
a.each do |e|
  if e > 5
    puts e
  end
end
#or
a.each {|e| puts e if e > 5}

#3. Now, using the same array from #2, use the "select" method to extract all odd numbers into a new array.
a.select {|x| x%2.0 != 0}
#or
a.select {|x| x%2 != 0}
#or
a.select {|x| x%2 == 1}
#or
a.select {|x| x.odd?}

#4. Append "11" to the end of the array. Prepend "0" to the beginning.
a << 11
a.unshift(0)

#5. Get rid of "11". And append a "3".
a.delete(11)
#or
a.pop
a << 3

#6. Get rid of duplicates without specifically removing any one value.
a.uniq #does not mutate the caller
a.uniq! #mutates the caller

#7. What's the major difference between an Array and a Hash?
# answer: With a hash, arbitray keys of any object type can be used not just integers
# so keys vs index and arrays are used for orders and hashes are good for a dictionary structure

#8. Create a Hash using both Ruby 1.8 and 1.9 syntax.
h = {:a => 1, :b => 2, :c => 3} #1.8
h = {a: 1, b: 2, c: 3} #1.9

#Suppose you have a h = {a:1, b:2, c:3, d:4}
#9. Get the value of key "b".
h[:b]

#10. Add to this hash the key:value pair {e:5}
h[:e] = 5

#13. Remove all key:value pairs whose value is less than 3.5
h.delete_if {|key, value| value < 3.5}

#or
h.each {|k,v| h.delete(k) if v < 3.5}

#14. Can hash values be arrays? Can you have an array of hashes? (give examples)
h = {1=>[1,"one"]} 

#or
h[:a] = [1, 2, 3, 4,]
a = [5, 6, 7, {x:10, y:11}]

#15. Look at several Rails/Ruby online API sources and say which one your like best and why.
# answer: overapi.com?