require 'dashing'
require_relative 'secrets'

configure do

  set :auth_token, Secrets.get['auth_token']

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
