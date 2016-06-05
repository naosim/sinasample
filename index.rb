# require 'sinatra'
require 'json'
require './src/domain/service/AddWordService.rb'
require './src/domain/model/phrase.rb'
require './src/infra/datasource/datasource.rb'

require './src/lib/package.rb'
# datasource
# wordRepositoryOnMemory = WordRepositoryOnMemory.new

# service
# addNewService = AddWordService.new wordRepositoryOnMemory

# get '/word/add' do
#   res = addNewService.add params['word']
#   JSON.generate res
#
# end
#
# post '/edit' do
#   body = request.body.read
#
#   if body == ''
#     status 400
#   else
#     body.to_json
#   end
# end
#
# get '/' do
#   send_file File.join(settings.public_folder, 'index.html')
# end
#
# get '/*/' do |path|
#   send_file File.join(settings.public_folder, path, 'index.html')
# end
#
# value = PhraseEntity.new
# p value.isNotExist
#
# TwitterSearchRepositoryNet.new.search(Phrase.new('java'))

# Phrase.new('java').phrase_repository.save
FindPhraseEntityRepository.new.search()[0].twitter_search_repository.search_twitter.each {|entity|
  entity.twitter_stock_repository.overwrite
}
