module Api
  module V1
    class ConferencesController < Api::BaseController
      load_resource find_by: :short_title
      respond_to :json

      # Disable forgery protection for any json requests. This is required for jsonp support
      skip_before_action :verify_authenticity_token

      def index
        render json: @conferences, adapter: Api::V1::SerializerAdapter, callback: params['callback']
      end

      def show
        render json: [@conference], adapter: Api::V1::SerializerAdapter, callback: params['callback']
      end
    end
  end
end
