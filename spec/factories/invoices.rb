# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    cfdi_digital_stamp { FFaker::DizzleIpsum.characters }
    user { create(:user) }
    invoice_uuid { Faker::Invoice.reference }
    emitter { create(:person) }
    receiver { create(:person) }
    amount_cents { Faker::Number.number(digits: 5) }
    amount_currency { Faker::Currency.code }
    emitted_at { Faker::Date.backward }
    expires_at { Faker::Date.backward }
  end
end
