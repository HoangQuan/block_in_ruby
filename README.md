# block_in_ruby

## **Block trong Ruby**


### **Mở đầu**

`Block` là một trong những tính năng quan trọng trong RUBY  nhưng lại thường bị bỏ qua nhất.

Khi mới bắt đầu với Ruby, tôi đã làm quen với lệnh `Yield` và có đôi chút khó hiểu với nó. `Yield` cũng là một dạng `Block`.

Bài viết này tôi sẽ giới thiệu cách mà một khối lệnh `bock` trong Ruby được thực thi và tiện ích của chúng.

Trước tiên mình sẽ dành chút thời gian để giải thích `Block là gì` 

### **What are ruby Block**

`Block` đơn giản là một khối lệnh nằng trong `do` và `end`, Chúng ta có 2 cách viết như sau:

1. Viết code trong `do` và `end` đối với đoạn code nhiều dòng


```ruby
[1, 2, 3].each do |n|
  puts "Number #{n}"
end
```

2. Viết code trong `{` và `}` đối với đoạn code ngắn một dòng.


```ruby
[1, 2, 3].each {|n| puts "Number #{n}"}
```

Cả hai cách viết đều cho ra những kết quả giống nhau. Tuy nhiên nếu khối code nhiều dòng thì bạn nên sử dụng `do...end` cho dễ đọc.

Cái này thì ai chả biết. Có quái gì hay ở đây đâu? đến đoạn này bạn đang tự hỏi như vậy phải không? :D

Đây chỉ là giới thiệu qua thôi hãy theo dõi tiếp để biết những điều thú vị nhé ^^



### **`Yield` hoạt động như thế nào?**

Quả thật, khi mới bắt đầu tìm hiểu ROR cũng là lúc mình bắt gặp lệnh `yield` và thật sự bối rối với cách hoạt động của nó (chỉ dùng thôi chứ chả hiểu nó hoạt động như thế nào) và làm sao truyền được tham số cho nó.

Cùng nhau  làm sáng tỏ cách thức hoạt động của nó thông qua một ví dụ dưới đây nhé:

```ruby
def my_method
  puts "reached the top"
  yield
  puts "reached the bottom"
end

my_method do
  puts "reached yield"
end

reached the top
reached yield
reached the bottom
 => nil

```

Như vậy có thể kết luận rằng:

Khi thực thi phương thức my_method thì các lệnh được thực thi lần lượt, khi gặp lệnh `yield` thì khối lệnh trong `yield` sẽ được thực hiện sau khi thực hiện xong thì sẽ tiếp tục thực thi các lệnh khác trong method.

![ruby_block_flow.png](/uploads/images/f817bb52ebf40f927e39324c5ca708c0aafde390/af08aea73102b4ccf388337e9e8139148ec411ce.png) 



Cũng như các bạn đã thấy, Nếu bạn đặt `yield` trong thân hàm của bạn thì khi gọi method nó sẽ mong đợi một `block` truyền vào để thực thi. 

```ruby
my_method do
  puts "reached yield"
end

```

Nếu bạn không truyền vào `block` mà `yield` mong muốn Ruby sẽ bắn ra một ngoại lệ và kết thục phương thức.

```ruby
hoangquan@hoangvanquan:~/data/reports/block_in_ruby$ ruby yield.rb 
reached the top
yield.rb:3:in `my_method': no block given (yield) (LocalJumpError)
	from yield.rb:7:in `<main>'


```

để tránh điều này bạn có thể dùng phương thức `block_given?`.


**Truyền tham số vào yield như thế nào**

Rõ ràng yield là phương thức đón nhận một `block` truyền vào và thực thi block đó. Vì vậy bạn có thể dễ dàng truyền vào tham số trong block và yield chỉ việc thực thi nó. Như sau:



```ruby
 def my_method2                                                                                                                                                                                           
   yield("Quân", "27")                                                                                                   
 end                                                                                                                     
                                                                                                                         
 my_method2 do |name, age|                                                                                               
    p "#{name} is #{age} years old"                                                                                       
 end 


hoangquan@hoangvanquan:~/data/reports/block_in_ruby$ ruby yield.rb 
"Quân is 27 years old"

````

Chú ý rằng biến mà bạn truyền vào chỉ có giá trị bên trong `block` thôi nhé.



### **`&block` (tham số đầu vào) là gì**

Có lẽ bạn đã từng thấy việc truyền vào phương thức một đối số dạng `&block` rất nhiều lần trong Ruby đúng ko? Đây là cách để truyền một block code vào trong một method. 

```ruby
def my_method(&block)
  puts block
  block.call
end

my_method { puts "Hello!" }


#<Proc:0x0000010124e5a8@tmp/example.rb:6>
Hello!
```


Bạn cũng có thể thấy ở vị dụ trên `block` được truyền vào như một đối số bình thường và nó thuộc class Proc. Để thực thi các lệnh trong `block` thì chúng ta dùng phương thức `call`.

Việc này hoàn toàn giống với việc sử dụng `yield`. Nhiều người thích dùng `block.call` hơn là sử dụng `yield`.

** Giá trị trả về **

`yield` trả về giá  trị bởi dòng cuối cùng trong `block`, hay nói cách khác `yield` trả về giá trị mà `block` trả về

```ruby
def my_method
    value = yield
    puts "value is: #{value}"
  end

  my_method do
    2
  end


 value is 2

```

### **`map(&:something)` làm việc như thế nào?**

Mình đã khá nhiều lần bắt gặp điều này trong khi làm việc với ROR, chẳng hạn như `.map(&:capitalize)` hoặc `.map(&:to_s)`...

Vậy chính xác thì `map(&:something)` làm việc như thế nào?

Nó sẽ biến các `symbol` thành các phương thức thông qua `to_proc` method, sau đó lặp và thực thi lần lượt các lệnh.

Bạn có thể gọi `yield` nhiều lần trong  phương thức, đó là cách cơ bản là vòng lặp thực hiện. 

Cụ thể như sau:

```ruby

  def my_map(array)
    new_array = []

    for element in array
      new_array.push yield element
    end

    new_array
  end

  my_map([1, 2, 3]) do |number|
    p number * 2
  end

hoangquan@hoangvanquan:~/data/reports/block_in_ruby$ ruby map.rb 
2
4
6

```

**Khởi tại đối tượng với giá trị mặc định**

Một điều khá thú vi là chúng ta có thể tạo giá trị mặc định cho một đối tượng với `ruby block`. Điều này có thể được thực hiện bằng cách gọi `yield(self)` trong khi bạn khởi tạo đối tượng. 
Trong context của phương thức `initialize`, `self` chính là đối tượng được khởi tạo:

```ruby
class Car
  attr_accessor :color, :doors

  def initialize
    yield(self)
  end
end

car = Car.new do |c|
  c.color = "Red"
  c.doors = 4
end

puts "My car's color is #{car.color} and it's got #{car.doors} doors."


My car's color is Red and it's got 4 doors.

```

### **`yield` dùng trong HTML tags**

Với tất cả các tiện ích của `block` nói trên. Nó được ứng dụng vào rất nhiều nơi trong một ứng dụng ROR. 

Ở bất kỳ một ứng dụng nào bạn cũng có thể thấy người ta sử dụng `yield` để include nội dung của các trang HTML vào trong một layout xây dựng chung.

Ngoài ra, rất nhiều tiện ích thông qua các views helper của Rails như: các tags, link_to ...cũng được sử dụng thông qua việc truyền vào phương thức những `block`.

Vậy chúng hoạt động như thế nào?



```ruby
def wrap_in_h1
  "<h1>#{yield}</h1>"
end

wrap_in_h1 { "Here's my heading" }

# => "<h1>Here's my heading</h1>"

wrap_in_h1 { "Ha" * 3 }

# => "<h1>HaHaHa</h1>"




```

`Block` là một cách lý tưởng để bạn `wrap` một khối `html động` vào trong một khối code tĩnh (ví dụ như layout).

 Chú ý rằng, Sức mạnh của việc sử dụng `block` thông qua các phương thức chính là bạn muốn tái sử dụng một phương thức nhưng lại trả ra một giá trị hoàn toàn khác.

Chẳng hạn như:

```ruby


def wrap_in_tags(tag, text)
  html = "<#{tag}>#{text}</#{tag}>"
  yield html
end

wrap_in_tags("span", "something") {|html| p html}
wrap_in_tags("title", "hello") {|html| p html}

hoangquan@hoangvanquan:~/data/reports/block_in_ruby$ ruby html_tag.rb 

"<span>something</span>"

"<title>hello</title>"

```

hoặc bạn cũng có thể sử lý hai công việc khác nhau với cùng chỉ một phương thức:

```Ruby
wrap_in_tags("span", "something") {|html| Mail.send(html)}
wrap_in_tags("title", "hello") {|html| Post.create(html)}

```

### **Tóm lại**

Nói tóm lại, `Block` là một khối lệnh mà bạn có thể truyền vào bất cứ phương thức nào và sau đó thực thi khối lệnh này bằng phương thức `yield` hoặc `block.call`.

`Block` mà cách để bạn `inject` code của mình vào một nơi nào đó trong method. Điều này có nghĩa là bạn có thể có một phương thức làm việc với nhiều cách khác nhau và trả ra các giá trị hoàn toàn khác nhau (phụ thuộc vào `block` truyền vào).

`Block` là một tính năng rất quan trọng mà nhiều lập trình viên ROR đã bỏ qua (như mình :D).

Các ví dụ trong bài viết được mình push lên [đây] (https://github.com/HoangQuan/block_in_ruby) nhé
