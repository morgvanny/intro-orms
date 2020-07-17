class Tweet
  attr_accessor :message, :username
  attr_reader :id
  @@connector = DB[:conn]

  def self.all
    tweets = @@connector.execute("SELECT * FROM tweets;").map do |tweet_hash|
      Tweet.new(tweet_hash)
    end
  end

  def self.all_by_username(u)
    tweets = @@connector.execute("SELECT * FROM tweets WHERE username = ?;", u).map do |tweet_hash|
      Tweet.new(tweet_hash)
    end
  end

  def initialize(props={})
    @message = props['message']
    @username = props['username']
    @id = props['id']
  end

  def self.create(props={})
    t = new(props)
    t.save
  end

  def update(message)
    sql = <<-SQL
    UPDATE tweets SET message = ? WHERE id = ?
    SQL
    @@connector.execute(sql, message, id)
  end

  def save
    @@connector.execute("INSERT INTO tweets (message, username) VALUES (?, ?);", @message, @username)
    self
  end
end
