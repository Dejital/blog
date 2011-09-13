require 'rack-rewrite'
require 'toto'
require 'haml'

# -----------------------------------------
# Rack configuration
# -----------------------------------------
use Rack::Static, :urls => ['/css', '/images', '/favicon.ico'], :root => 'public'
use Rack::CommonLogger

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end


# -----------------------------------------
# Set some sane encoding defaults
# -----------------------------------------
# Encoding.default_internal = Encoding::UTF_8
Encoding.default_external = Encoding::UTF_8


# -----------------------------------------
# Create and configure a toto instance
# -----------------------------------------
toto = Toto::Server.new do
  set :url,       "http://sergey.heroku.com/"
  set :author,    "Sergey Kutserubov"                       # blog author
  set :title,     "Sergey Kutserubov"                       # site title
  set :root,      "index"                                   # page to load on /
  set :date,      lambda {|now| now.strftime("%m/%d/%Y") }  # date format for articles
  set :markdown,  :smart                                    # use markdown + smart-mode
  set :disqus,    false                                     # disqus id, or false
  set :summary,   :max => 150, :delim => /~/                # length of article summary and delimiter
  set :ext,       'mkd'                                     # file extension for articles
  set :cache,     28800                                     # cache duration, in seconds
  set :disqus,    false
  set :date,      lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
  set :to_html,   lambda {|path, page, ctx| Haml::Engine.new(File.read("#{path}/#{page}.haml"), { :format => :html5, :ugly => true, :attr_wrapper => '"' }).render(ctx) }
end

run toto
