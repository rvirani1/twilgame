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
  session[:rightNum] = Random.rand(5)
  session[:tries] = 3
  Twilio::TwiML::Response.new do |r|
    r.Gather :action => '/guess', :timeout => 15 do |g|
      g.Say 'Welcome to the number guessing game. You have 3 tries left. Please guess a number from zero to five and hit the pound sign'
    end
  end.text
end

post '/guess' do
  session[:tries] -= 1
  if params[:Digits].to_i == session[:rightNum]
    Twilio::TwiML::Response.new do |r|
      r.Say 'You guessed the right number.'
      r.Play "https://www.freesound.org/people/zut50/sounds/162395/download/162395__zut50__yay.mp3"
    end.text
  else
    if params[:Digits].to_i > session[:rightNum]
      diff = "You were too high"
    else
      diff = "You were too low"
    end
    if params[:tries] != 0
      Twilio::TwiML::Response.new do |r|
        r.Say diff + "You have " + session[:tries].to_s + " tries left"
        r.Gather :timeout => 15, :action => '/guess' do |g|
          g.Say 'Please enter a number from zero to five and hit the pound sign'
        end
      end.text
    else
      Twilio::TwiML::Response.new do |r|
        r.Say "You're out of tries. Too bad."
        r.Play "https://www.freesound.org/people/guitarguy1985/sounds/52079/download/52079__guitarguy1985__diminishedslide.wav"
      end.text
    end
  end
end

get '/' do
  "Learning Ruby on Heroku"
end

