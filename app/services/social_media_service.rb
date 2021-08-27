class SocialMediaService
  attr_accessor :twitter_response, :facebook_response
  
  def initialize
  end

  def call
    @twitter_response = Media::Twitter.all
    @facebook_response = Media::Facebook.all

    format_response(twitter: @twitter_response, facebook: @facebook_response)
  end

  private

  def format_response(twitter: [], facebook: [])
    {
      twitter: twitter,
      facebook: facebook
    }
  end
end