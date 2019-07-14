json.array! @geolocs do |geolocation|
  json.partial! 'api/v1/shared/geolocation', geolocation: geolocation
end
