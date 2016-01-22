require 'haml'
require './lib/helper'

module DoCSS
  class Server
    def self.call(env)
      request = Rack::Request.new env
      request_pathname = Pathname.new(request.path).basename
      files = Dir.glob("#{request_pathname}.html.haml")
      if files.empty?
        return [404, {}, [""]]
      else
        response = Rack::Response.new
        response.write "<!DOCTYPE html>"
        response.write "<html>"
        response.write "  <head>"
        response.write "    <link href='/css/site.css' rel='stylesheet' type='text/css'></link>"
        response.write "  </head>"
        response.write "  <body>"
        response.write "    <div class='container objects'>"
        File.open(files.first, "r") do |file|
          uninterpreted = file.read
          response.write Haml::Engine.new(uninterpreted).render
        end
        response.write "    </div>"
        response.write "  </body>"
        response.write "</html>"
        response.status = 200
        response.finish
      end
    end
  end
end
