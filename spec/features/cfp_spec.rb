require 'spec_helper'

feature Conference do

  let!(:conference) { create(:conference) }
  let!(:organizer_role) { Role.find_by(name: 'organizer', resource: conference) }
  let!(:organizer) { create(:user, role_ids: [organizer_role.id]) }

  shared_examples 'add and update cfp' do
    scenario 'adds a new cfp', feature: true, js: true do
      expected_count = Cfp.count + 1

      sign_in organizer

      visit new_admin_conference_program_cfp_path(conference.short_title)

      click_button 'Create Cfp'

      expect(flash)
          .to eq('Creating the call for papers failed. ' +
          "Start date can't be blank. End date can't be blank.")

      today = Date.today - 1
      page.execute_script(
      "$('#registration-period-start-datepicker').val('#{today.strftime('%d/%m/%Y')}')")
      page.execute_script(
      "$('#registration-period-end-datepicker').val('#{(today + 6).strftime('%d/%m/%Y')}')")

      choose 'cfp[program_attributes][speaker_proposals_req_speaker_event_reg]', option: 'true'
      choose 'cfp[program_attributes][speaker_proposals_req_bio]', option: 'true'
      choose 'cfp[program_attributes][speaker_proposals_req_subtitle]', option: 'true'
      choose 'cfp[program_attributes][speaker_proposals_req_commercial]', option: 'false'
      choose 'cfp[program_attributes][speaker_proposals_req_track]', option: 'false'
      choose 'cfp[program_attributes][speaker_proposals_req_difficulty_level]', option: 'false'

      click_button 'Create Cfp'

      # Validations
      expect(flash)
          .to eq('Call for papers successfully created.')
      expect(find('#start_date').text).to eq(today.strftime('%A, %B %-d. %Y'))
      expect(find('#end_date').text).to eq((today + 6).strftime('%A, %B %-d. %Y'))
      expect(page).to have_content('Speakers todo: remind to register for event Yes')
      expect(page).to have_content('Speakers todo: remind to fill out bio Yes')
      expect(page).to have_content('Speakers todo: remind to add subtitle Yes')
      expect(page).to have_content('Speakers todo: remind to add a commercial No')
      expect(page).to have_content('Speakers todo: remind to add track No')
      expect(page).to have_content('Speakers todo: remind to add difficulty level No')

      expect(Cfp.count).to eq(expected_count)
    end

    scenario 'update cfp', feature: true, js: true do
      conference.program.cfp = create(:cfp)
      expected_count = Cfp.count

      sign_in organizer
      visit admin_conference_program_cfp_path(conference.short_title)
      click_link 'Edit'

      # Validate update with empty start date will not saved
      page.execute_script(
          "$('#registration-period-start-datepicker').val('')")
      click_button 'Update Cfp'
      expect(flash)
          .to eq('Updating call for papers failed. ' +
                    "Start date can't be blank.")

      # Fill in date
      today = Date.today - 9
      page.execute_script(
        "$('#registration-period-start-datepicker').val('#{today.strftime('%d/%m/%Y')}')")
      page.execute_script(
        "$('#registration-period-end-datepicker').val('#{(today + 14).strftime('%d/%m/%Y')}')")

      # Set options
      choose 'cfp[program_attributes][speaker_proposals_req_speaker_event_reg]', option: 'true'
      choose 'cfp[program_attributes][speaker_proposals_req_bio]', option: 'true'
      choose 'cfp[program_attributes][speaker_proposals_req_subtitle]', option: 'false'
      choose 'cfp[program_attributes][speaker_proposals_req_commercial]', option: 'false'
      choose 'cfp[program_attributes][speaker_proposals_req_track]', option: 'true'
      choose 'cfp[program_attributes][speaker_proposals_req_difficulty_level]', option: 'true'

      click_button 'Update Cfp'

      # Validations
      expect(flash)
          .to eq('Call for papers successfully updated.')
      expect(find('#start_date').text).to eq(today.strftime('%A, %B %-d. %Y'))
      expect(find('#end_date').text).to eq((today + 14).strftime('%A, %B %-d. %Y'))
      expect(page).to have_content('Speakers todo: remind to register for event Yes')
      expect(page).to have_content('Speakers todo: remind to fill out bio Yes')
      expect(page).to have_content('Speakers todo: remind to add subtitle No')
      expect(page).to have_content('Speakers todo: remind to add a commercial No')
      expect(page).to have_content('Speakers todo: remind to add track Yes')
      expect(page).to have_content('Speakers todo: remind to add difficulty level Yes')
      expect(Cfp.count).to eq(expected_count)
    end
  end

  describe 'organizer' do
    it_behaves_like 'add and update cfp'
  end
end
