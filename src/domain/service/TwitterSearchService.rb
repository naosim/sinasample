require './src/domain/model/phrase.rb'
require './src/domain/model/tweet.rb'

class Twitter検索サービス
  def initialize
    @検索フレーズリポジトリ = C検索フレーズリポジトリ.new
  end
  def 検索
    @検索フレーズリポジトリ.から.すべて取得.個別要素を処理{|検索フレーズエンティティ|
      検索フレーズエンティティ.で.twitter検索リポジトリ.を.検索.し.個別要素を処理 {|ツイートエンティティ|
        ツイートエンティティ.を.twitter保存リポジトリ.に.上書き保存
      }
    }
  end
end
