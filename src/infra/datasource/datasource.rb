require 'sqlite3'
require './src/domain/model/phrase.rb'
require './src/domain/model/tweet.rb'
require './src/infra/datasource/twitter_client.rb'
require 'twitter'

db = SQLite3::Database.new("test.db")
sql = <<-EOF
CREATE TABLE IF NOT EXISTS phrase (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  phrase  TEXT,
  create_datetime DATE
);
EOF

sql2 = <<-EOF
CREATE TABLE IF NOT EXISTS stock_tweet (
  id TEXT PRIMARY KEY,
  user_name,
  user_screen_name,
  full_text,
  tweet_time DATE,
  url,
  retweet_count INTEGER,
  favorite_count INTEGER,
  valiable_count INTEGER,
  phrase_id,
  create_datetime DATE,
  update_datetime DATE
);
EOF
db.execute(sql)
# db.execute("drop table stock_tweet");
db.execute(sql2)

def getDb
  db = SQLite3::Database.new("test.db")
  return db
end

class PhraseRepository
  @@db = getDb()
  def save
    @@db.execute("insert into phrase(phrase, create_datetime) values (?, current_timestamp)", @phrase.value)
  end
end

class PhraseEntityRepository
  @@db = getDb()
  def remove
    @db.execute("DELETE FROM phrase WHERE id = ?", @value)
  end
end

class C検索フレーズリポジトリ
  @@db = getDb()
  def すべて取得
    @@db.execute("SELECT * FROM phrase").map {|row|
      PhraseEntity.new(PhraseId.new(row[0]), Phrase.new(row[1]))
    }
  end
end

class TwitterSearchRepository
  @@client = nil
  def 検索
    if @@client == nil then
      @@client = get_twitter_client
    end

    @@client.search(@phrase_entity.phrase.value, count: 100, lang: 'ja',result_type: "recent")
      .take(100)
      .map { |tw|
        if tw.retweet? then
          tw = tw.retweeted_tweet
        end
        TweetEntity.new(
          TwitterId.new(tw.id),
          TwitterUser.new(TwitterUserName.new(tw.user.name), TwitterUserScreenName.new(tw.user.screen_name)),
          TwitterFullText.new(tw.full_text),
          TwitterTweetTime.new(tw.created_at),
          TweetUrl.new(tw.url.to_s),
          TwitterRetweetCount.new(tw.retweet_count),
          TwitterFavoriteCount.new(tw.favorite_count),
          @phrase_entity
        )
      }
      .select {|tweet_entity|
        p tweet_entity
        tweet_entity.valiable_count.value >= 1
      }
  end
end

class TwitterStockRepository
  @@db = getDb()
  def initialize(tweet_entity)
    @tweet_entity = tweet_entity
  end
  def 上書き保存
    p @tweet_entity.user.screen_name.value
    is_exist = @@db.execute("SELECT count(*) FROM stock_tweet WHERE id = ?", @tweet_entity.id.value)[0][0] > 0
    if is_exist then
      @@db.execute(
        "update stock_tweet SET retweet_count = ?, favorite_count = ?, valiable_count = ?, update_datetime = current_timestamp WHERE id = ?",
        @tweet_entity.retweet_count.value,
        @tweet_entity.favorite_count.value,
        @tweet_entity.valiable_count.value,
        @tweet_entity.id.value
      )
    else
      @@db.execute(
        "insert into stock_tweet values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, current_timestamp)",
        @tweet_entity.id.value,
        @tweet_entity.user.name.value,
        @tweet_entity.user.screen_name.value,
        @tweet_entity.full_text.value,
        @tweet_entity.tweet_time.value.strftime("%Y-%m-%d %X:%M:%S"),
        @tweet_entity.url.value,
        @tweet_entity.retweet_count.value.to_i,
        @tweet_entity.favorite_count.value.to_i,
        @tweet_entity.valiable_count.value.to_i,
        @tweet_entity.phrase_entity.id.value
      )
    end
  end
end

class C保存済みツイート検索リポジトリ
  @@db = getDb()
  def 検索
    @@db.execute("SELECT * FROM stock_tweet where phrase_id = ? ORDER BY valiable_count DESC", @phrase_entity.id.value).map {|row|
      TweetEntity.new(
        TwitterId.new(row[0]),
        TwitterUser.new(TwitterUserName.new(row[1]), TwitterUserScreenName.new(row[2])),
        TwitterFullText.new(row[3]),
        TwitterTweetTime.new(row[4]),
        TweetUrl.new(row[5]),
        TwitterRetweetCount.new(row[6]),
        TwitterFavoriteCount.new(row[7]),
        @phrase_entity
      )
    }
  end
end
