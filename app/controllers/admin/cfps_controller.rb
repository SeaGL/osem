module Admin
  class CfpsController < Admin::BaseController
    load_and_authorize_resource :conference, find_by: :short_title
    load_and_authorize_resource :program, through: :conference, singleton: true
    load_and_authorize_resource through: :program, singleton: true

    def show; end

    def new
      @cfp = @program.build_cfp
    end

    def edit; end

    def create
      @cfp = @program.build_cfp(cfp_params)
      send_mail_on_cfp_dates_updates = @cfp.notify_on_cfp_date_update?

      if @cfp.save
        ConferenceCfpUpdateMailJob.perform_later(@conference) if send_mail_on_cfp_dates_updates
        redirect_to admin_conference_program_cfp_path,
                    notice: 'Call for papers successfully created.'
      else
        flash.now[:error] = "Creating the call for papers failed. #{@cfp.errors.full_messages.join('. ')}."
        render :new
      end
    end

    def update
      @cfp = @program.cfp
      @cfp.assign_attributes(cfp_params)

      send_mail_on_cfp_dates_updates = @cfp.notify_on_cfp_date_update?

      if @cfp.update_attributes(cfp_params)
        ConferenceCfpUpdateMailJob.perform_later(@conference) if send_mail_on_cfp_dates_updates
        redirect_to admin_conference_program_cfp_path(@conference.short_title),
                    notice: 'Call for papers successfully updated.'
      else
        flash.now[:error] = "Updating call for papers failed. #{@cfp.errors.to_a.join('. ')}."
        render :new
      end
    end

    def destroy
      if @cfp.destroy
        redirect_to admin_conference_program_cfp_path, notice: 'Call for Papers was successfully deleted.'
      else
        redirect_to admin_conference_program_cfp_path, error: 'An error prohibited this Call for Papers from being destroyed: '\
        "#{@cfp.errors.full_messages.join('. ')}."
      end
    end

    private

    def cfp_params
      # Do a bit of param massaging.
      # 1. For some reason fields_for @cfp.program in the view produces a slightly
      # wrong parameter name that can't be used with assign/update_attributes.
      # Fix this by renaming :program to :program_attributes.
      # 2. Starting with a CFP model object such as
      # @cfp = #<Cfp id: 1, ... , program_id: 1>
      # running .update_attributes on that with {... "program_attributes"=>{"speaker_proposals_req_speaker_event_reg"=>"true"}}
      # should simply update the program associated with that CFP. Unfortunately,
      # it also sets @cfp.program_id to nil. Not clear why as update_attributes
      # is supposed to merge rather than replace, but the workaround is to inject
      # the @cfp's program_id into the incoming parameters so the link is not lost.

    cfp = params.require(:cfp)
      cfp[:program_attributes] = cfp.delete(:program) if cfp.has_key? :program
      cfp[:program_attributes][:id] = @cfp.program.id

      cfp.permit(:start_date, :end_date,
                 program_attributes: [ :id, :speaker_proposals_req_speaker_event_reg, :speaker_proposals_req_bio, :speaker_proposals_req_subtitle, :speaker_proposals_req_commercial, :speaker_proposals_req_track, :speaker_proposals_req_difficulty_level])
    end
  end
end
