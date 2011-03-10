require 'rack'

# Killswitch is a Rack Middleware to disable access to a Rails (or Rack) app
#   Inspired by rack-maintenance - https://github.com/ddollar/rack-maintenance
#   (Credit where credit is due!)

class Rack::Killswitch
  attr_reader :app, :options
  
  def initialize(app, options={})
    @app     = app
    @options = options

    raise(ArgumentError, 'Must specify a trigger file (:trigger)') unless options[:trigger]
    raise(ArgumentError, 'Must specify a holding page (:page)') unless options[:page]
  end
  
  def call(env)
    # If the site is down and the user visits the defined override path, set a cookie so he can get in
    if down? and options[:override_path] and env['REQUEST_URI'] == options[:override_path]
      # HTTP 303: "See Other" 
      # The response to the request can be found under a different URI and SHOULD be retrieved using a
      # GET method on that resource. The new URI is not a substitute reference for the originally requested
      # resource. The 303 response MUST NOT be cached.
      response = Rack::Response.new([''], 303, { 'Location' => '/', 'Content-Length' => '0' })
      response.set_cookie("override_killswitch", {:value => "true", :path => "/", :expires => Time.now+24*60*60})
      response.finish
    elsif down? and not cookie_set?(env)
      # Ensure holding page exists
      raise "Holding page file #{options[:page]} does not exist" unless File.exists?(options[:page])
      
      # Get what's in there and send it over to the unsuspecting user
      data = File.read(options[:page])
      [ 503, { 'Content-Type' => 'text/html', 'Content-Length' => data.length.to_s }, [data] ] 
    else
      # Business as usual
      app.call(env)
    end
  end
  
  private
  def cookie_set?(env)
    # true as String because it's a cookie!
    Rack::Request.new(env).cookies['override_killswitch'] == "true"
  end

  def down?
    File.exists?(options[:trigger])
  end
end