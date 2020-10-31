module Api
  module V1
    class SerializerAdapter < ActiveModelSerializers::Adapter::Json
      def serializable_hash(*args)
        super(*args).merge!(version: 1)
      end
    end
  end
end
