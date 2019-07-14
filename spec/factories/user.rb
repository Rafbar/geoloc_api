FactoryBot.define do
  sequence :email do |i|
    "test#{i}@testmail.com"
  end

  factory :user do
    name 'Jane'
    username 'Doe'
    email
    password '1234567'
  end
end
