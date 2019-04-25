# frozen_string_literal: true

require 'test_plugin_helper'

module ForemanRegister
  class SeedsTest < ActiveSupport::TestCase
    setup do
      Foreman.stubs(:in_rake?).returns(true)
    end

    test 'seeds registration template kind' do
      seed
      seeded_kinds = TemplateKind.all.map(&:name)
      assert_includes seeded_kinds, 'registration'
    end

    test 'seeds registration provisioning templates' do
      seed
      assert ProvisioningTemplate.unscoped.where(default: true).exists?
      expected_template_names = [
        'Linux registration default'
      ]

      seeded_templates = ProvisioningTemplate.unscoped.where(default: true, vendor: 'ForemanRegister').pluck(:name)

      expected_template_names.each do |template|
        assert_includes seeded_templates, template
      end
    end

    private

    def seed
      User.current = FactoryBot.build(:user, admin: true,
                                             organizations: [], locations: [])
      load Rails.root.join('db', 'seeds.rb')
    end
  end
end
