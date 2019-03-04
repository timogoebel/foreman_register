# frozen_string_literal: true

module ForemanRegister
  class Engine < ::Rails::Engine
    engine_name 'foreman_register'

    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/services"]

    initializer 'foreman_register.load_app_instance_data' do |app|
      ForemanRegister::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_register.register_plugin', before: :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_register do
        requires_foreman '>= 1.22'

        # Registration Facet
        register_facet(ForemanRegister::RegistrationFacet, :registration_facet) do
          set_dependent_action :destroy
        end

        # extend host show page
        extend_page('hosts/show') do |context|
          context.add_pagelet :main_tabs,
                              name: N_('Enrollment'),
                              partial: 'hosts/registration_tab'
        end
      end
    end

    config.to_prepare do
      Host::Managed.send(:include, ForemanRegister::HostExtensions)
    rescue StandardError => e
      Rails.logger.warn "ForemanRegister: skipping engine hook (#{e})"
    end
  end
end
