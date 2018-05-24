class AddSpeakerProposalRequirementsToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :speaker_proposals_req_speaker_event_reg, :boolean, default: true
    add_column :programs, :speaker_proposals_req_bio, :boolean, default: true
    add_column :programs, :speaker_proposals_req_subtitle, :boolean, default: true
    add_column :programs, :speaker_proposals_req_commercial, :boolean, default: true
    add_column :programs, :speaker_proposals_req_track, :boolean, default: true
    add_column :programs, :speaker_proposals_req_difficulty_level, :boolean, default: true
  end
end
