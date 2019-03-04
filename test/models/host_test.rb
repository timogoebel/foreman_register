# frozen_string_literal: true

require 'test_plugin_helper'

class HostTest < ActiveSupport::TestCase
  let(:host) { FactoryBot.create(:host) }

  describe '#registration_token' do
    let(:expected_token) do
      'eyJhbGciOiJIUzI1NiJ9.eyJob3N0X2lkIjoxLCJpYXQiOjE1NTE3Mjk1NjEsImp0aSI6ImVmNjExY2U3OTgwZjRjMjljNzFjZTRlMWJiZTM4ZTEwMDJlYzQzMDM5OGI2ZmUzYjg0NGVlZWY0MjkwNzlhNTciLCJleHAiOjE1NTE4MTU5NjEsIm5iZiI6MTU1MTcyNTk2MX0.BPGX-hFUnQfSOQjy057UA66OT9YBl1H08rSMyQxZMus'
    end

    it 'generates a jwt token' do
      host.registration_facet!.update(jwt_secret: 'wtLAhNwPI5JhsUk3LfA7tg==')
      ForemanRegister::RegistrationToken.stubs(:iat).returns(1_551_729_561)
      assert_equal expected_token, host.registration_token.token
    end
  end

  describe '#registration_url' do
    it 'generates a registration url' do
      ForemanRegister::RegistrationToken.stubs(:encode).returns('some-jwt-token')
      assert_equal 'http://foreman.some.host.fqdn/foreman_register/hosts/register?token=some-jwt-token', host.registration_url
    end
  end
end
