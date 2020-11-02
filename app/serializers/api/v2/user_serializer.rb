module Api
  module V2
    class UserSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers

      attributes :affiliation, :biography, :gravatar_id, :id, :name
      link(:self) { user_url(object.id) }
      type :user
    end
  end
end
