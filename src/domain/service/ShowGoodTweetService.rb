require './src/domain/model/phrase.rb'
require './src/domain/model/tweet.rb'

class ShowGoodTweetService
  def show
    FindPhraseEntityRepository.new.search().map {|phrase_entity|
      phrase_entity.find_twitter_stock_repository.find
    }
  end
end
