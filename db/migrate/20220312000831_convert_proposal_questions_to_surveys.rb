# frozen_string_literal: true

# Prior to the existence of OSEM’s survey feature, SeaGL customized the CFP
# response form with several additional questions. This migration moves the
# custom data out of the CFP responses and into retroactively created surveys.
class ConvertProposalQuestionsToSurveys < ActiveRecord::Migration[7.0]
  def up
    convert 'seagl2017',       :diversity, :first_time
    convert 'seagl2018',       :diversity, :first_time
    convert 'seagl2019',       :diversity, :first_time
    convert 'seagl2020', :pnw, :diversity, :first_time
    convert 'seagl2021', :pnw, :diversity, :first_time

    remove_column :events, :pnw,        :boolean                 # 20200710065434_add_pnw_to_events.rb
    remove_column :events, :first_time, :boolean, default: false # 20170614025428_add_first_time_to_events.rb
    remove_column :events, :diversity,  :boolean, default: false # 20170613224853_add_diversity_to_events.rb
  end

  def down
    raise NotImplementedError
  end

  private

  TITLE = 'Speaker Questionnaire'
  DESCRIPTION = 'Responses to this survey were retroactively created from CFP submissions.'
  QUESTIONS = {
    pnw:        'I am local to the Pacific Northwest',
    diversity:  'I identify as a member of a group that is historically under-represented in technology',
    first_time: 'This will be my first time speaking at a conference'
  }.freeze

  def convert(short_title, *attributes)
    say_with_time "Convert #{attributes.map(&:inspect).to_sentence} to survey in #{short_title}" do
      conference = Conference.find_by_short_title!(short_title)
      survey = Survey.create!(surveyable: conference, target: :during_proposal, title: TITLE, description: DESCRIPTION)
      questions = attributes.to_h { |a| [a, survey.survey_questions.create!(kind: :boolean, title: QUESTIONS[a])] }

      conference.program.speakers.each do |speaker|
        replied = questions.reduce(false) do |result, (attribute, question)|
          answers = speaker.proposals(conference).map(&attribute).compact
          next result unless answers.present?

          question.survey_replies.create! user: speaker, text: answers.any? ? 'Yes' : 'No'
        end

        survey.survey_submissions.create! user: speaker if replied
      end
    end
  end
end
