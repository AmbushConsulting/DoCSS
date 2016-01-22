require './lib/indexer'
require './lib/server'
require 'sass/plugin/rack'

Sass::Plugin.options[:css_location] = 'assets/css'
root = 'assets'

use Rack::Reloader
use Sass::Plugin::Rack
use DoCSS::Indexer
use Rack::Static,
  :urls => Dir.glob("#{root}/*").map { |fn| fn.gsub(/#{root}/, '')},
  :root => root,
  :index => 'index.html',
  :header_rules => [[:all, {'Cache-Control' => 'public, max-age=3600'}]]
run DoCSS::Server
