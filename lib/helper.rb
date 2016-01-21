require 'haml'
require 'haml/filters'
require 'html2haml'
require 'tempfile'

def build &block
  bare_html = capture_haml do
    yield
  end
  indented_html = indent(bare_html)
  html_md = add_markdown indented_html
  bare_haml = hamlfy_html(bare_html)
  indented_haml = indent(bare_haml)
  haml_md = add_markdown indented_haml
  capture_haml do
    yield
    haml_tag(:div, class: 'object-code') do
      haml_tag(:div, class: 'haml') do
        haml_concat Haml::Engine.new("%pre\n" + html_md).render.gsub(/\<pre>(<pre>.*<\/pre>)<\/pre>/, '\1')
      end
      haml_tag(:div, class: 'html') do
        haml_concat Haml::Engine.new("%pre\n" + haml_md).render.gsub(/\<pre>(<pre>.*<\/pre>)<\/pre>/, '\1')
      end
    end
  end
end

def indent string
  string.each_line.map do |line|
    "        " + line
  end
end

def add_markdown string
  "  :markdown\n" + string.join
end

def hamlfy_html code
  File.open("tmp_erb", "w+") do |file|
    file.write(code)
  end
  h = File.open("tmp_erb", "r")
  bare_haml = `html2haml tmp_erb`
  h.close
  File.delete(h)
  bare_haml
end
