require './src/lib/package.rb'
require './src/domain/model/tweet.rb'
class PhraseId < ValueObject
end

class PhraseRepository
  def initialize(phrase)
    @phrase = phrase
  end
  def save
  end
end

class PhraseEntityRepository
  def initialize(phrase_entity)
    @phrase_entity = phrase_entity
  end
  def remove
  end
end

class FindPhraseEntityRepository
  def search
  end
end

class Phrase < ValueObject
  def phrase_repository
    PhraseRepository.new(self)
  end
end

class PhraseEntity
  attr_reader :id, :phrase, :PhraseRepository
  include Entity

  def initialize(id, phrase)
    @id = id
    @phrase = phrase
  end

  def twitter_search_repository
    TwitterSearchRepository.new(self)
  end

  def find_twitter_stock_repository
    FindTwitterStockRepository.new(self)
  end
end
