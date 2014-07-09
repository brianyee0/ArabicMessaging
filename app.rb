require 'sinatra'
require 'twilio-ruby'

# A hack around multiple routes in Sinatra
def get_or_post(path, opts={}, &block)
  get(path, opts, &block)
  post(path, opts, &block)
end

# Home page and reference
get '/' do
  @title = "Home"
  erb :home
end

# Voice Request URL
get_or_post '/voice/?' do
  response = Twilio::TwiML::Response.new do |r|
    r.Say 'Congratulations! You\'ve successfully deployed ' \
          'the Twilio HackPack for Heroku and Sinatra!', :voice => 'woman'
  end
  response.text
end

# SMS Request URL
get_or_post '/sms/?' do
  the_text = params[:Body]

  case the_text
  when /understanding/i
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "Watch the next Prophet’s Stories video at http://prophetstories.org/english/, Mohammed & the Heavenly Books"
    end
    response.text
  when /prophetadam|prophet adam/i
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "Watch the next video at http://prophetstories.org/english/, Adam & Hawa & the Robes of Righteousness"
    end
    response.text
  when /alter/i
    # send note to BH
    notify_bh(the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "As u wait for a response, consider watching the next video at http://prophetstories.org/english/, Adam & Hawa & the Robes of Righteousness"
    end
    response.text
  when /shame/i
    # send note to BH
    notify_bh(the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "As u wait for a response, consider watching the next video at http://prophetstories.org/english/, Nuh & the Boat of Salvation"
    end
    response.text
  when /way/i
    # send note to BH
    notify_bh(the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "As u wait for a response, consider watching the next video at http://prophetstories.org/english/, Ibrahim & the Sacrifice of Redemption"
    end
    response.text
  when /sacrifice/i
    # send note to BH
    notify_bh(the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "As u wait for a response, consider watching the next Prophet’s Stories video at http://prophetstories.org/english/, Musa and the Blood of Sacrifice"
    end
    response.text
  when /blood/i
    # send note to BH
    notify_bh(the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "As u wait for a response, consider watching the next video at http://prophetstories.org/english/, Musa and the Law"
    end
    response.text
  when /cleanse/i
    # send note to BH
    notify_bh(the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "As u wait for a response, consider watching the next video at http://prophetstories.org/english/, Isa & the Healing of the Blind"
    end
    response.text
  when /follow/i
    # send note to BH
    notify_bh(the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "As u wait for a response, consider watching the next video at http://prophetstories.org/english/, Yahya & His Testimony of Isa"
    end
    response.text
  when /sign/i
    # send note to BH
    notify_bh(the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "As u wait for a response, consider watching the next video at http://prophetstories.org/english/, Isa & the Victory over Death"
    end
    response.text
  when /isa/i
    # send note to BH
    notify_bh(the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "As u wait for a response, consider watching the next video at http://prophetstories.org/english/, Allah’s Way & the Prophet Pointing to Isa"
    end
    response.text
  when /straight path|straightpath/i
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "Thank you for watching the Prophet’s Stories.  Would you be interested in a study of the signs of the prophets in the Holy Books?"
    end
    response.text
  else 
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "Response not understood.  Please go to http://prophetstories.org to find out more."
    end
    response.text
  end
end

# Twilio Client URL
get_or_post '/client/?' do
  TWILIO_ACCOUNT_SID = ENV['TWILIO_ACCOUNT_SID'] || TWILIO_ACCOUNT_SID
  TWILIO_AUTH_TOKEN = ENV['TWILIO_AUTH_TOKEN'] || TWILIO_AUTH_TOKEN
  TWILIO_APP_SID = ENV['TWILIO_APP_SID'] || TWILIO_APP_SID
  
  if !(TWILIO_ACCOUNT_SID && TWILIO_AUTH_TOKEN && TWILIO_APP_SID)
    return "Please run configure.rb before trying to do this!"
  end
  @title = "Twilio Client"
  capability = Twilio::Util::Capability.new(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
  capability.allow_client_outgoing(TWILIO_APP_SID)
  capability.allow_client_incoming('twilioRubyHackpack')
  @token = capability.generate
  erb :client
end

def notify_bh(the_text)

  @client = Twilio::REST::Client.new(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)

  @client.account.messages.create(
    :from => '+12487315922',
    :to => '+17347883363',
    :body => "Someone texted #{the_text}"
  )

  # do something
end
