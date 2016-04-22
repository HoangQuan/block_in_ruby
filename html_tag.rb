def wrap_in_tags(tag, text)
  html = "<#{tag}>#{text}</#{tag}>"
  yield html
end

wrap_in_tags("span", "something") {|html| p html}
wrap_in_tags("title", "hello") {|html| p html}
