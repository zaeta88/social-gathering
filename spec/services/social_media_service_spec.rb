require 'rails_helper'

describe "SocialMediaService" do

  describe "#call" do
    describe "when the medias are successfully requested" do
      it "returns the twitter and facebook responses in a single response" do
        tweet_1 = Media::Twitter.new.assign_attributes(username: "user1", tweet: "tweet1 test")
        post_1 = Media::Facebook.new.assign_attributes(name: "friend1", status: "status1 test")
        post_2 = Media::Facebook.new.assign_attributes(name: "friend2", status: "status2 test")

        allow(Media::Twitter).to receive(:all).and_return([tweet_1])
        allow(Media::Facebook).to receive(:all).and_return([post_1, post_2])

        social_media_instance = SocialMediaService.new
        response = social_media_instance.call

        expect(response).to eq({twitter: [tweet_1], facebook: [post_1, post_2]})
      end
    end
  end
end