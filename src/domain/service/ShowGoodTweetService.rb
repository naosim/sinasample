require './src/domain/model/phrase.rb'
require './src/domain/model/tweet.rb'

class C良質なツイート表示サービス
  def initialize
    @検索フレーズリポジトリ = C検索フレーズリポジトリ.new
  end
  def 取得
    @検索フレーズリポジトリ.から.すべて取得.して.個別要素を変換 {|検索フレーズエンティティ|
      検索フレーズエンティティ.で.保存済みツイート.を.検索.する
    }
  end
end
