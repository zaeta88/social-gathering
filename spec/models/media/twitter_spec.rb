require 'rails_helper'

describe Media::Twitter do
  describe "#all" do
    describe "when a request returns the tweets successfully" do
      describe "when the response is a collection" do
        it "returns the tweets" do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(OpenStruct.new(status: 200, body: JSON.generate(TWEETS_RESPONSE)))
          
          result = Media::Twitter.all

          expect(result.count).to eq(2)
          expect(result.first[:name]).to eq(TWEETS_RESPONSE.first["tweet"])
          expect(result.last[:tweet]).to eq(TWEETS_RESPONSE.last["tweet"])
        end
      end

      describe "when the response is not a collection" do
        it "returns an empty array" do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_return({})
          
          result = Media::Twitter.all
  
          expect(result).to be_empty
        end
      end
    end

    describe "when a request has an unexpected exception" do
      it "returns an empty array" do
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(StandardError)
        
        result = Media::Twitter.all

        expect(result).to be_empty
      end
    end
  end
end

TWEETS_RESPONSE = [
{
  "tweet": "First Tweet.",
  "username": "@first-tweet-user"
},{
  "tweet": "Second Tweet.",
  "username": "@second-tweet-user"
}]
