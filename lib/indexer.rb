require 'pygments'
require 'redcarpet'

module DoCSS
  class HTMLwithPygments < Redcarpet::Render::HTML
    include Redcarpet::Render::SmartyPants
    def block_code(code, language)
      Pygments.highlight(code, lexer: language)
    end
    def codespan(code)
      %Q|<span style="color:#E05757;background-color:#ECECEC;padding:5px;">#{code}</span>|
    end
    def image(link, title, alt_text)
      path = Pathname.new(link)
      image_pathname = path.basename
      title ||= alt_text.capitalize
      %Q|<img src="/images/#{image_pathname}" title="#{title}" alt-text="#{alt_text}"/>|
    end
  end
  class Indexer
    def initialize(app)
      @app = app
    end
    def call(env)
      request = Rack::Request.new env
      path = Pathname.new(request.path)
      if request.path == '/index.html' || request.path == '/'
        rendered_html = File.open('README.md', "rb") do |md|
          markdown = Redcarpet::Markdown.new(HTMLwithPygments, autolink: true, fenced_code_blocks: true, strikethrough: true)
          markdown.render(md.read)
        end
        response = Rack::Response.new
        response.write "<!DOCTYPE html>\n"
        response.write "<html>\n"
        response.write "  <head>\n"
        response.write "    <link href='/css/site.css' rel='stylesheet' type='text/css'></link>\n"
        response.write "    <style>img {max-width:600px; display:block;}</style>\n"
        response.write "  </head>\n"
        response.write "  <body>\n"
        response.write "    <div class='container objects'>\n"
        response.write rendered_html
        response.write "    </div>\n"
        response.write "  </body>\n"
        response.write "</html>"
        response.status = 200
        response.finish
      else
        @app.call env
      end
    end
  end
end
