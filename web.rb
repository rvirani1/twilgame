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
    r.Gather :action => '/guess' do |g|
      g.Say 'Welcome to the number guessing game. Please guess a number from zero to nine'
    end
    r.Say 'You waited too long. Goodbye'
  end.text
end

post '/guess' do
  if params[:Digits].to_i == session[:rightNum]
    Twilio::TwiML::Response.new do |r|
      r.Say 'You guessed the right number. You be baller dude'
      r.Play "http://com.twilio.music.rock.s3.amazonaws.com/jlbrock44_-_Apologize_Guitar_Deep_Fried.mp3"
    end.text
  else
    if params[:Digits].to_i > session[:rightNum]
      diff = "You were too high"
    else
      diff = "You were too low"
    end
    Twilio::TwiML::Response.new do |r|
      r.Say 'You guessed the wrong number.'
      r.Gather :action => '/guess' do |g|
        g.Say 'Please guess a number from zero to nine' + diff
      end
      r.Say 'You waited too long. Goodbye'
    end.text
  end
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

