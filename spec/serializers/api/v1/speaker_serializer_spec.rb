require 'spec_helper'
describe Api::V1::SpeakerSerializer, type: :serializer do
  let(:speaker) { create(:user, name: 'John Doe', affiliation: 'JohnDoesInc', biography: nil) }

  let(:serializer) do
    options = { serializer: Api::V1::SpeakerSerializer, adapter: :json, root: 'speaker' }
    ActiveModelSerializers::SerializableResource.new(speaker, options)
  end

  context 'speaker does not have biography' do
    it 'sets name and affiliation' do
      expected_json = {
        speaker: {
          name: 'John Doe',
          affiliation: 'JohnDoesInc',
          biography: nil
        }
      }.to_json

      expect(serializer.to_json).to eq expected_json
    end
  end

  context 'speaker has biography' do
    before{ speaker.update_attributes(biography: 'Doest of all Jon Does') }

    it 'sets name, affiliation and biography' do
      expected_json = {
        speaker: {
          name: 'John Doe',
          affiliation: 'JohnDoesInc',
          biography: 'Doest of all Jon Does'
        }
      }.to_json

      expect(serializer.to_json).to eq expected_json
    end
  end
end
