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
  the_from_num = params[:From]

  case the_text
  when /understanding/i
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "(AR) Welcome to the Prophet Stories. Watch new vids daily. Watch 1st vid @ http://bit.ly/1nrVVfR. Txt 3134371451 for help.Txt STOP to stop.Msg&Data rates may apply."
    end
    response.text
  when /prophetadam|prophet adam/i
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "(AR) Watch the next video at http://prophetstories.org/michigan/en_03/, Adam & Hawa & the Robes of Righteousness"
    end
    response.text
  when /تغير/i
    # send note to BH
    notify_bh(the_from_num, the_text);
    response = Twilio::TwiML::Response.new do |r|
#      r.Sms "(AR) As u wait for a response, consider watching the next video at http://prophetstories.org/michigan/en_03/, Adam & Hawa & the Robes of Righteousness"
      r.Sms "كما كنت انتظر ردا"
    end
    response.text
  when /تحريف/i
    # send note to BH
    notify_bh(the_from_num, the_text);
    response = Twilio::TwiML::Response.new do |r|
#      r.Sms "(AR) Test Response"
      r.Sms "وبينما تنتظر الرد نرجو منك أن تشاهد المقطع التالي آدم و حواء و رداء التقوى على الرابط"
    end
    response.text
  when /shame/i
    # send note to BH
    notify_bh(the_from_num, the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "(AR) As u wait for a response, consider watching the next video at http://prophetstories.org/michigan/en_04/, Nuh & the Boat of Salvation"
    end
    response.text
  when /way/i
    # send note to BH
    notify_bh(the_from_num, the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "(AR) As u wait for a response, consider watching the next video at http://prophetstories.org/michigan/en_05/, Ibrahim & the Sacrifice of Redemption"
    end
    response.text
  when /sacrifice/i
    # send note to BH
    notify_bh(the_from_num, the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "(AR) As u wait for a response, consider watching the next Prophet's Stories video at http://prophetstories.org/michigan/en_06/, Musa and the Blood of Sacrifice"
    end
    response.text
  when /blood/i
    # send note to BH
    notify_bh(the_from_num, the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "(AR) As u wait for a response, consider watching the next video at http://prophetstories.org/michigan/en_07/, Musa and the Law"
    end
    response.text
  when /cleanse/i
    # send note to BH
    notify_bh(the_from_num, the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "(AR) As u wait for a response, consider watching the next video at http://prophetstories.org/michigan/en_08/, Isa & the Healing of the Blind"
    end
    response.text
  when /follow/i
    # send note to BH
    notify_bh(the_from_num, the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "(AR) As u wait for a response, consider watching the next video at http://prophetstories.org/michigan/en_09/, Yahya & His Testimony of Isa"
    end
    response.text
  when /sign/i
    # send note to BH
    notify_bh(the_from_num, the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "(AR) As u wait for a response, consider watching the next video at http://prophetstories.org/michigan/en_10/, Isa & the Victory over Death"
    end
    response.text
  when /isa/i
    # send note to BH
    notify_bh(the_from_num, the_text);
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "(AR) As u wait for a response, consider watching the next video at http://prophetstories.org/michigan/en_11/, Allah’s Way & the Prophet Pointing to Isa"
    end
    response.text
  when /straight path|straightpath/i
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "(AR) Thanks 4 watching the Prophet's Stories. As u wait for a response, would u be interested in a study of the signs of the prophets? Reply YES or NO"
    end
    response.text
  when /yes/i
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "(AR) Thanks for watching the prophet stories videos. As you have indicated your interest in further study of the Holy Books, you will be contacted shortly"
    end
    response.text
  when /no/i
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "(AR) Thank you for taking the time to watch the Prophets Stories. What keeps you from pursuing further study?"
    end
    response.text
  else 
    response = Twilio::TwiML::Response.new do |r|
      r.Sms "(AR) Response not understood. Please go to http://prophetstories.org/michigan/en_01/ or text 3134371451 & explain what you need help with."
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

def notify_bh(the_from_num, the_text)
  account_sid = ENV['TWILIO_ACCOUNT_SID'] || TWILIO_ACCOUNT_SID
  auth_token = ENV['TWILIO_AUTH_TOKEN'] || TWILIO_AUTH_TOKEN

  @client = Twilio::REST::Client.new account_sid, auth_token

  @client.account.sms.messages.create(
    :from => '+12487315922',
    :to => '+13134371451',
    :body => "The system has received an arabic text (#{the_text}) from #{the_from_num}"
  )

  # do something
end
