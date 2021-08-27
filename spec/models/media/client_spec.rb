require 'rails_helper'

describe Media::Client do
  describe "initialize" do
    it "return the instance values" do
      instance = Media::Client.new
      expect(instance.base_url).to eq(Rails.configuration.x.medias.fetch(:base_url))
    end
  end

  describe "#get" do
    describe "when a request returns a successfully response" do
      describe "When the response is a collection" do
        it "returns the response body" do
          response = [{success: true}]
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(OpenStruct.new(status: 200, body: response))
          
          instance = Media::Client.new
          instance.get(path: "test-path") do |result|
            expect(result).to eq(response)
          end
        end
      end

      describe "When the response is not a collection" do 
        it "returns the response body" do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_return({})
          
          instance = Media::Client.new
          result = instance.get(path: "test-path") do |result|
            expect(result).to be_empty
          end
        end
      end
    end

    describe "when a request has an unexpected exception" do
      it "returns an empty array" do
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(StandardError)
        
        instance = Media::Client.new
        result = instance.get(path: "test-path") do |result|
          expect(result).to be_empty
        end
      end
    end
  end
end
