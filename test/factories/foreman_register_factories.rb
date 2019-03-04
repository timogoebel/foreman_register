# frozen_string_literal: true

FactoryBot.define do
  factory :registration_facet, class: 'ForemanRegister::RegistrationFacet' do
    jwt_secret { SecureRandom.base64 }
    host
  end
end

FactoryBot.modify do
  factory :host do
    trait :with_registration_facet do
      association :registration_facet, factory: :registration_facet, strategy: :build
    end
  end
end
