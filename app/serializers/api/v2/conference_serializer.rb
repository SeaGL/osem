module Api
  module V2
    class ConferenceSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers

      attributes :id, :title
      has_many(:events) { object.program.selected_event_schedules&.map(&:event) }
      link(:self) { conference_url(object.short_title) }
      type :conference
    end
  end
end
