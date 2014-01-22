a = [1, 2, 3, 3]

do_something = Proc.new do |outer|
  outer.each do |e|
    puts e + 5
  end
end

do_something.call a
puts a
