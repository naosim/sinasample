class AddWordService
  def initialize(wordRepository)
    @wordRepository = wordRepository
  end

  def add(word)
    @wordRepository.add word
  end
end
