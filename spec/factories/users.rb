FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "test123" }
    password_confirmation { "test123" }
  end
end
