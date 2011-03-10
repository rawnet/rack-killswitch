require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "rack-killswitch"
  gem.homepage = "http://github.com/rawnet/rack-killswitch"
  gem.license = "MIT"
  gem.summary = %Q{Rack middleware to disable access to a site with a twist}
  gem.description = %Q{Live broadcast on app showing fire and blood everywhere? Image hosting site flooded with pornography? Or some other urgent reason to take your app offline in a hurry? rack-killswitch to the rescue.}
  gem.email = "christian@rawnet.com"
  gem.authors = ["Christian Sutter"]
  gem.add_runtime_dependency 'rack', '>= 1.1.0'
end
Jeweler::RubygemsDotOrgTasks.new