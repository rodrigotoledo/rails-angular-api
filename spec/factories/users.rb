require 'faker'

FactoryBot.define do
  factory :user do
    name { 'RToledo Info'}
    email { 'user@email.com' }
    password { '123456' }
    password_confirmation { '123456' }
  end
end
