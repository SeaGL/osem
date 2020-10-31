require 'spec_helper'

describe Api::V1::TrackSerializer, type: :serializer do
  let(:track) { create(:track) }

  let(:serializer) do
    options = { serializer: Api::V1::TrackSerializer, adapter: :json }
    ActiveModelSerializers::SerializableResource.new(track, options)
  end

  it 'sets guild, name, color' do
    expected_json = {
      track: {
        guid: track.guid,
        name: track.name,
        color: track.color
      }
    }.to_json

    expect(serializer.to_json).to eq expected_json
  end
end
