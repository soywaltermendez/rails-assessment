FactoryBot.define do
  factory :person do
    name { Faker::Name.first_name }
    rfc { Faker::Number.number(digits: 20) }
  end
end
