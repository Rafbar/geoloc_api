FactoryBot.define do
  factory :geo_location do
    key "www.google.com"
    ip "192.168.0.1"
    country_code "PL"
    city "Poznan"
    zip "zip_code"
    latitude "latitude"
    longitude "longitude"
    workflow_state "new"
  end
end
