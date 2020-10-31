module Api
  module V1
    class TrackSerializer < ActiveModel::Serializer
      attributes :guid, :name, :color
    end
  end
end
