# frozen_string_literal: true

require 'test_plugin_helper'

module ForemanRegister
  class RegistrationFacetTest < ActiveSupport::TestCase
    it 'generates jwt_secret before creation' do
      facet = FactoryBot.create(:registration_facet)
      assert_not_nil facet.jwt_token
    end
  end
end
