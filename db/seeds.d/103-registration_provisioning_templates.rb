# frozen_string_literal: true

User.as_anonymous_admin do
  plugin_provisioning_templates = Dir["#{ForemanRegister::Engine.root}/app/views/foreman/unattended/provisioning_templates/**/*.erb"]

  SeedHelper.import_templates(plugin_provisioning_templates, 'ForemanRegister')
end
