require 'spec_helper'
describe Api::V1::RoomSerializer, type: :serializer do
  let(:room) { create(:room) }

  let(:serializer) do
    options = { serializer: Api::V1::RoomSerializer, adapter: :json }
    ActiveModelSerializers::SerializableResource.new(room, options)
  end

  it 'set guid, name and description' do
    expected_json = {
      room: {
        guid: room.guid,
        name: room.name,
        description: ''
      }
    }.to_json

    expect(serializer.to_json).to eq expected_json
  end
end
