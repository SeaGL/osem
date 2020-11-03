module Api
  module V2
    class EventSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers

      attributes :abstract, :beginning, :end, :id, :title
      has_many :speakers, key: :presenters
      has_one :room
      has_one :track
      link(:self) { conference_program_proposal_url(object.program.conference.short_title, object.id) }
      type :event

      def beginning
        timezone = object.program.conference.timezone

        # OSEM internally stores the wrong time and fakes the time zone in views.
        ActiveSupport::TimeZone.new(timezone)
          .local_to_utc(object.time)
          .in_time_zone(timezone)
      end

      def end
        beginning + object.event_type.length.minutes
      end
    end
  end
end
