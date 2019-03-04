# frozen_string_literal: true

require 'test_plugin_helper'

module ForemanRegister
  class HostsControllerTest < ActionController::TestCase
    let(:host) { FactoryBot.create(:host, :managed) }
    let(:registration_token) { host.registration_token }

    describe '#register' do
      it 'shows a registration script' do
        get :register, params: { token: registration_token }
        assert_response :success
        assert_not_nil assigns('host')
        assert_includes @response.body, '#!/bin/bash'
        assert_includes @response.body, host.name
      end

      it 'enables build mode for the host' do
        get :register, params: { token: registration_token }
        assert_response :success
        assert_equal true, host.reload.build
      end

      it 'shows an error if no token is passed' do
        get :register
        assert_response :bad_request
      end
    end
  end
end
