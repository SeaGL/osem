module Api
  module V2
    class EventSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers

      attribute(:end) { object.time + object.event_type.length.minutes }
      attribute :time, key: :beginning
      attributes :abstract, :id, :title
      has_many :speakers, key: :presenters
      has_one :room
      has_one :track
      link(:self) { conference_program_proposal_url(object.program.conference.short_title, object.id) }
      type :event
    end
  end
end
