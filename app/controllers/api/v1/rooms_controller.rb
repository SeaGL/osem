module Api
  module V1
    class RoomsController < Api::BaseController
      load_resource :conference, find_by: :short_title
      respond_to :json

      # Disable forgery protection for any json requests. This is required for jsonp support
      skip_before_action :verify_authenticity_token

      def index
        rooms = if @conference
                  @conference.venue ? @conference.venue.rooms : Room.none
                else
                  Room.all
                end

        respond_with rooms, adapter: :json, callback: params[:callback]
      end
    end
  end
end
