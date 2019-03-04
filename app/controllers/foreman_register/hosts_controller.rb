# frozen_string_literal: true

module ForemanRegister
  class HostsController < ::ForemanRegister::ApplicationController
    # Skip default filters
    FILTERS = [
      :require_login,
      :session_expiry,
      :update_activity_time,
      :set_taxonomy,
      :authorize,
      :verify_authenticity_token
    ].freeze

    FILTERS.each do |f|
      skip_before_action f
    end

    before_action :set_admin_user
    before_action :skip_secure_headers
    before_action :find_host

    def register
      @host.setBuild
      render :register, layout: false, formats: [:text]
    end

    private

    def find_host
      token = params[:token]
      jwt_payload = ForemanRegister::RegistrationToken.new(token).decode
      return render_error(message: 'Registration token is missing or invalid.') unless jwt_payload

      @host = Host::Managed.find_by!(id: jwt_payload['host_id'])
    end

    def skip_secure_headers
      SecureHeaders.opt_out_of_all_protection(request)
    end

    def render_error(message:, status: :bad_request)
      render plain: "#!/bin/sh\necho \"#{message}\"\nexit 1\n", status: status
    end
  end
end
