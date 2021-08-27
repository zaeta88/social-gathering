class HomeController < ApplicationController
  def index
    media_response = SocialMediaService.new.call

    respond_to do |format|
      format.json { render json: media_response }
      format.html { render json: media_response }
    end
  end
end