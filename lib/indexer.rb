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
  end
  class Indexer
    def initialize(app)
      @app = app
    end
    def call(env)
      status, headers, body = @app.call env
      File.open('assets/index.html', "w") do |file|
        rendered_html = ''
        File.open('README.md', "rb") do |md|
          markdown = Redcarpet::Markdown.new(HTMLwithPygments, autolink: true, fenced_code_blocks: true, strikethrough: true)
          foo = md.read
          rendered_html = markdown.render(foo)
        end
        file.write "<!DOCTYPE html>\n"
        file.write "<html>\n"
        file.write "  <head>\n"
        file.write "    <link href='/css/site.css' rel='stylesheet' type='text/css'></link>\n"
        file.write "    <style>img {max-width:600px; display:block;}</style>\n"
        file.write "  </head>\n"
        file.write "  <body>\n"
        file.write "    <div class='container objects'>\n"
        file.write rendered_html
        file.write "    </div>\n"
        file.write "  </body>\n"
        file.write "</html>"
      end
      [status, headers, body]
    end
  end
end
