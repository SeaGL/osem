module Api
  module V2
    class TrackSerializer < ActiveModel::Serializer
      attributes :color, :description, :id, :name
      type :track
    end
  end
end
