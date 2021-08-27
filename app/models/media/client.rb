require "faraday"

module Media
  class Client
    HTTP_OK_CODE = 200
    attr_reader :base_url

    def initialize
      @base_url = Rails.configuration.x.medias.fetch(:base_url)
    end

    def get(path:, body: {}, headers: {})
      endpoint = "#{@base_url}#{path}"

      response = connection.get(endpoint, body, headers)

      case response.status
      when HTTP_OK_CODE then yield response.body
      when Faraday::ClientError, Faraday::ServerError then response.error!
      end
    rescue => e
      Rails.logger.error e.message
      return []
    end

    def connection
      Faraday.new do |conn|
        conn.request(:retry, max: 2,
                             interval: 0.05,
                             interval_randomness: 0.5,
                             backoff_factor: 2,
                             exceptions: [Exception, 'Timeout::Error'])
      
        conn.adapter(:net_http)
      end
    end
  end
end