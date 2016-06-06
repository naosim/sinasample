require 'sinatra'
require 'json'
require './src/domain/model/phrase.rb'
require './src/infra/datasource/datasource.rb'

require './src/lib/package.rb'

require './src/domain/service/ShowGoodTweetService.rb'
require './src/domain/service/TwitterSearchService.rb'

get '/show' do
  list = ShowGoodTweetService.new.show.map {|tweet_entity_list|
    tweet_entity_list.map {|tweet_entity|
      {
        id: tweet_entity.id.value,
        user: {
          name: tweet_entity.user.name.value,
          screen_name: tweet_entity.user.screen_name.value,
        },
        phrase_entity: {
          phrase_id: tweet_entity.phrase_entity.id.value,
          phrase: tweet_entity.phrase_entity.phrase.value,
        },
        full_text: tweet_entity.full_text.value,
        valiable_count: tweet_entity.valiable_count.value
      }
    }
  }
  JSON.generate(list)
end

get '/search' do
  TwitterSearchService.new.search
  "OK"
end

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/*/' do |path|
  send_file File.join(settings.public_folder, path, 'index.html')
end
