def wrap_in_h1
  "<h1>#{yield}</h1>"
end

wrap_in_h1 { "Here's my heading" }

# => "<h1>Here's my heading</h1>"

wrap_in_h1 { "Ha" * 3 }

