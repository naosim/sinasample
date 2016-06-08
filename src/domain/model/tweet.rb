# ID ： tw.id
# ツイート本文： tw.full_text
# アカウント名： tw.user.name
# スクリーンネーム： tw.user.screen_name
# ツイート数　： tw.user.statuses_count
# フォロー数　： tw.user.friends_count
# フォロワー数： tw.user.followers_count
# リツイート数： tw.retweet_count
# お気に入り数： tw.favorite_count
# 添付画像URL： tw.media.first.expanded_url.to_s
# リンク先URL： tw.urls.map { |t| t.expanded_url.to_s }

class TwitterId < ValueObject
end

class TwitterUserName < ValueObject
end

class TwitterUserScreenName < ValueObject
end

class TwitterUserScreenName < ValueObject
end

class TwitterFullText < ValueObject
end

class TwitterTweetTime < ValueObject
end

class TwitterRetweetCount < ValueObject
end

class TwitterFavoriteCount < ValueObject
end

class ValiableCount < ValueObject
end

class TweetUrl < ValueObject
end

class TwitterUser
  attr_reader :name, :screen_name
  def initialize(name, screen_name)
    @name = name
    @screen_name = screen_name
  end
end

class TweetEntity
  attr_reader :id, :user, :full_text, :tweet_time, :url, :retweet_count, :favorite_count, :phrase_entity
  def initialize(twitter_id, twitter_user, full_text, tweet_time, url, retweet_count, favorite_count, phrase_entity)
    @id = twitter_id
    @user = twitter_user
    @full_text = full_text
    @tweet_time = tweet_time
    @retweet_count = retweet_count
    @favorite_count = favorite_count
    @phrase_entity = phrase_entity
    @url = url
  end

  def valiable_count
    ValiableCount.new(@favorite_count.value + @retweet_count.value)
  end

  def twitter保存リポジトリ
    TwitterStockRepository.new(self)
  end
end


class TwitterSearchResult
  attr_reader :phrase, :tweet_list

end

class TwitterSearchRepository
  def initialize(phrase_entity)
    @phrase_entity = phrase_entity
  end
  def 検索
  end
end

class TwitterStockRepository
  def initialize(tweet_entity)
    @tweet_entity = tweet_entity
  end
  def 上書き保存
    p @tweet_entity
  end
end

class C保存済みツイート検索リポジトリ
  def initialize(phrase_entity)
    @phrase_entity = phrase_entity
  end
  def 検索
  end
end
