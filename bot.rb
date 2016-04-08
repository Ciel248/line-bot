require "sinatra"
require "json"
require "faraday"
require "settingslogic"

class Settings < Settingslogic
  source File.join(File.dirname(__FILE__), "config", "application.yml")
end

LINEBOT_API_HOST = "https://trialbot-api.line.me"
TO_CHANNEL = "1383378250" # FIXED_VALUE
EVENT_TYPE = "138311608800106203" # FIXED_VALUE

helpers do
  def post_text(to, text)
    content = {
      contentType: 1,
      toType: 1,
      text: text
    }

    post_event(to, content)
  end

  def post_event(to, content)
    body = {
      to: [to],
      toChannel: TO_CHANNEL,
      eventType: EVENT_TYPE,
      content: content
    }.to_json

    conn = Faraday.new LINEBOT_API, ssl: true
    conn.post do |req|
      req.url "/v1/events"
      req.headers["Content-type"]                 = "application/json; charset=UTF-8"
      req.headers["X-Line-ChannelID"]             = Settings.linebot.channel_id,
      req.headers["X-Line-ChannelSecret"]         = Settings.linebot.channel_secret,
      req.headers["X-Line-Trusted-User-With-ACL"] = Settings.linebot.mid,
      req.body = body
    end
  end
end

post "/callback" do
  params = JSON.parse request.body.read
  post_text(params["result"]["content"]["from"], "hello")
end
