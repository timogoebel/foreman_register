# frozen_string_literal: true

FactoryBot.define do
  factory :registration_facet do
    jwt_secret { SecureRandom.base64 }
  end
end
