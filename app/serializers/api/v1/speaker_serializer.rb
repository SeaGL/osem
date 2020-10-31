module Api
  module V1
    class SpeakerSerializer < ActiveModel::Serializer
      include ActionView::Helpers::TextHelper

      attributes :name, :affiliation, :biography

      delegate :name, to: :object
    end
  end
end
