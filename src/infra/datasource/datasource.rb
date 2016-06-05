require 'sqlite3'
require './src/domain/model/phrase.rb'
require './src/domain/model/tweet.rb'
require './src/infra/datasource/twitter_client.rb'
require 'twitter'

db = SQLite3::Database.new("test.db")
sql = <<-EOF
create table phrase (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  phrase  TEXT,
  create_datetime DATE
);
EOF

sql2 = <<-EOF
create table stock_tweet (
  id TEXT PRIMARY KEY,
  user_name,
  user_screen_name,
  full_text,
  tweet_time,
  retweet_count INTEGER,
  favorite_count INTEGER,
  valiable_count INTEGER,
  phrase_id,
  create_datetime DATE,
  update_datetime DATE
);
EOF
# db.execute(sql)
# db.execute(sql2)

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

class FindPhraseEntityRepository
  @@db = getDb()
  def search
    @@db.execute("SELECT * FROM phrase").map {|row|
      PhraseEntity.new(PhraseId.new(row[0]), Phrase.new(row[1]))
    }
  end
end

class TwitterSearchRepository
  @@client = nil
  def search_twitter
    if @@client == nil then
      @@client = get_twitter_client
    end
    p @@client

    @@client.search(@phrase_entity.phrase.value, count: 100, lang: 'ja',result_type: "popular")
      .take(100)
      .map { |tw|
        TweetEntity.new(
          TwitterId.new(tw.id),
          TwitterUser.new(TwitterUserName.new(tw.user.name), TwitterUserScreenName.new(tw.user.screen_name)),
          TwitterFullText.new(tw.full_text),
          TwitterTweetTime.new(tw.created_at),
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
  def overwrite
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
      p "insert"
      @@db.execute(
        "insert into stock_tweet values (?, ?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, current_timestamp)",
        @tweet_entity.id.value,
        @tweet_entity.user.name.value,
        @tweet_entity.user.screen_name.value,
        @tweet_entity.full_text.value,
        @tweet_entity.tweet_time.value.to_s,
        @tweet_entity.retweet_count.value.to_i,
        @tweet_entity.favorite_count.value.to_i,
        @tweet_entity.valiable_count.value.to_i,
        @tweet_entity.phrase_entity.id.value
      )
    end
  end
end
