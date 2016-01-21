require 'haml'
require 'haml/filters'
require 'html2haml'
require 'tempfile'
require "pygments"

def build_docss &block
  bare_html = capture_haml &block
  bare_haml = hamlfy_html(bare_html)

  html_md = build_source_output(bare_html)
  haml_md = build_source_output(bare_haml, lang: 'haml')

  capture_haml do
    yield
    haml_tag(:div, class: 'object-code') do
      haml_tag(:div, class: 'html') do
        haml_concat html_md
      end
      haml_tag(:div, class: 'haml') do
        haml_concat haml_md
      end
    end
  end
end

def remove_whitespace string
  string.gsub(/\n/, '&#x000A;')
end

def highlight (raw_string, lexer: 'html')
  Pygments.highlight raw_string, lexer: lexer
end

def build_source_output(raw_html_string, lang: 'html')
  html_dirty = highlight(raw_html_string, lexer: lang)
  html_md = remove_whitespace(html_dirty)
end

def hamlfy_html code
  Html2haml::HTML.new(code).render.rstrip
end
