require 'twitter'
def get_twitter_client
  Twitter::REST::Client.new(
    consumer_key:        'xxxx',
    consumer_secret:     'xxxx',
    access_token:        'xxxx',
    access_token_secret: 'xxxx'
  )
end
