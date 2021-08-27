require 'rails_helper'

describe Media::Facebook do
  describe "#all" do
    describe "when a request returns the posts successfully" do
      describe "when the response is a collection" do
        it "returns the facebook posts" do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(OpenStruct.new(status: 200, body: JSON.generate(FACEBOOK_RESPONSE)))
          
          result = Media::Facebook.all

          expect(result.count).to eq(3)
          expect(result.first[:name]).to eq(FACEBOOK_RESPONSE.first["name"])
          expect(result.first[:status]).to eq(FACEBOOK_RESPONSE.last["status"])
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
        
        result = Media::Facebook.all

        expect(result).to be_empty
      end
    end
  end
end

FACEBOOK_RESPONSE = [
  {
    "name": "Friend One",
    "status": "First test status"
  },{
    "name": "Friend Two",
    "status": "Second test status"
  },{
    "name": "Friend Three",
    "status": "Third test status"
  }]
