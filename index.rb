require 'sinatra'
require 'json'
require './src/domain/model/phrase.rb'
require './src/infra/datasource/datasource.rb'

require './src/lib/package.rb'

require './src/domain/service/ShowGoodTweetService.rb'
require './src/domain/service/TwitterSearchService.rb'

twitter検索サービス = Twitter検索サービス.new
良質なツイート表示サービス = C良質なツイート表示サービス.new

get '/show' do
  list = 良質なツイート表示サービス.取得.して.個別要素を変換 {|tweet_entity_list|
    tweet_entity_list.map {|tweet_entity|
      p tweet_entity.tweet_time.value
      p tweet_entity.tweet_time.value.to_s
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
        valiable_count: tweet_entity.valiable_count.value,
        url: tweet_entity.url.value,
        tweet_time: tweet_entity.tweet_time.to_s
      }
    }
  }
  # p list
  JSON.generate(list)
end

get '/search' do
  twitter検索サービス.検索.する
  "OK"
end

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/*/' do |path|
  send_file File.join(settings.public_folder, path, 'index.html')
end

twitter検索サービス.検索
