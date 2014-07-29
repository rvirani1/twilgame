require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'pry'
enable :sessions

# put your own credentials here
account_sid = 'AC32ae359915491493721d304076e2db17'
auth_token = '8466dfddd99695943abcc64161e9db05'

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new account_sid, auth_token

post '/newcall' do
  session[:callSid] = params[:CallSid]
  session[:rightNum] = Random.rand(9)
  Twilio::TwiML::Response.new do |r|
    r.Say 'Welcome to the number guessing game. Please guess a number'
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

