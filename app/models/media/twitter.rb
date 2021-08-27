module Media
  class Twitter
    include ActiveModel::AttributeAssignment
    attr_accessor :username, :tweet

    def self.client
      Client.new
    end

    def self.all
      path = Rails.configuration.x.medias.fetch(:twitter)
      client.get(path: path) do |body|
        tweets = JSON.parse(body)

        tweets.each do |tweet|
          if tweet["username"]
            user_tweet = new
            user_tweet.assign_attributes(username: tweet["username"], tweet: tweet["tweet"])
          end
        end
      end
    rescue => e
      Rails.logger.error e
      return []
    end
  end 
end
