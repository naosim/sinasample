require './src/domain/model/phrase.rb'
require './src/domain/model/tweet.rb'

class TwitterSearchService
  def search
    FindPhraseEntityRepository.new.search().each{|phrase_entity|
      phrase_entity.twitter_search_repository.search_twitter.each {|entity|
        entity.twitter_stock_repository.overwrite
      }
    }
  end
end
