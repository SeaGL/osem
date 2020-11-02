module Api
  module V2
    class RoomSerializer < ActiveModel::Serializer
      attributes :id, :name
      type :room
    end
  end
end
