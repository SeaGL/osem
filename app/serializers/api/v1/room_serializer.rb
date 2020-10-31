module Api
  module V1
    class RoomSerializer < ActiveModel::Serializer
      attributes :guid, :name, :description

      # FIXME: just giving suseconferenceclient something to play with
      def description
        ''
      end
    end
  end
end
