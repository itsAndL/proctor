module TurboStreamRenderer
  extend ActiveSupport::Concern

  included do
    private

    def render_turbo_stream_update(options = {})
      streams = []

      streams << turbo_stream.replace('share-link', ShareLinkComponent.new(assessment: @assessment)) if options[:update_share_link]

      if options[:update_email_inviting]
        streams << turbo_stream.replace('email-inviting', EmailInvitingComponent.new(assessment: @assessment))
      end

      if options[:update_candidates_list]
        streams << turbo_stream.replace('candidates-list',
          CandidatesListComponent.new(
            assessment: @assessment,
            **options[:update_candidates_list]
          )
        )
      end

      if options[:update_bulk_inviting]
        streams << turbo_stream.replace('bulk-inviting', BulkInvitingComponent.new(assessment: @assessment))
      end

      streams << turbo_stream.replace('notification', NotificationComponent.new(notice: options[:notice], alert: options[:alert])) if options[:notice] || options[:alert]

      render turbo_stream: streams
    end
  end
end
