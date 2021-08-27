module Media
  class Facebook
    include ActiveModel::AttributeAssignment
    attr_accessor :name, :status

    def self.client
      Client.new
    end

    def self.all
      path = Rails.configuration.x.medias.fetch(:facebook)
      client.get(path: path) do |body|
        posts = JSON.parse(body)

        posts.each do |post|
          if post["name"]
            facebook_post = new
            facebook_post.assign_attributes(name: post["name"], status: post["status"])
          end
        end
      end
    rescue => e
      Rails.logger.error e
      return []
    end
  end 
end
