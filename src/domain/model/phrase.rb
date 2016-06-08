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

class C検索フレーズリポジトリ
  def すべて取得
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

  def twitter検索リポジトリ
    TwitterSearchRepository.new(self)
  end

  def 保存済みツイート
    C保存済みツイート検索リポジトリ.new(self)
  end
end
