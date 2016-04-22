def my_method
  puts "reached the top"
  yield if block_given?
  puts "reached the bottom"
end

#my_method

#my_method do
#  puts "reached yield"
#end

def my_method2
  yield("Quân", "27")
end

my_method2 do |name, age|
  p "#{name} is #{age} years old"
end 
