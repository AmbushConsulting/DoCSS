require "haml"
require "./lib/helper"

out = Haml::Engine.new(File.read("./test.html.haml")).render

File.open("./out/test.html", "w") do |file|
  file.write out
end
