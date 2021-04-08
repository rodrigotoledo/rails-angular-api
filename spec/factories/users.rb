require 'faker'

FactoryBot.define do
  factory :user do
    name { 'RToledo Info'}
    email { 'user@email.com' }
    password { '123456' }
    password_confirmation { '123456' }
  end

  factory :custom_user, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { '123456' }
    password_confirmation { '123456' }
  end
end
