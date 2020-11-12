module Api
  module V2
    class ConferencesController < Api::BaseController
      load_resource find_by: :short_title
      respond_to :json

      def show
        headers['Access-Control-Allow-Origin'] = '*'

        render json: @conference, adapter: :json_api, include: ['**']
      end
    end
  end
end
