require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
enable :sessions

get '/newcall' do
  #session[:twilioID] = params[]
  Twilio::TwiML::Response.new do |r|
    r.Say 'Hello Monkey'
  end.text
end


get '/foo' do
  session[:message] = 'Hello World!'
  redirect to('/bar')
end

get '/bar' do
  session[:message]   # => 'Hello World!'
end

get '/' do
  "Learning Ruby on Heroku"
end

