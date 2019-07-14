json.cache_if! geolocation.resolved?, [geolocation.cache_key], expires_in: 24.hours do
  json.call(geolocation, :key, :ip, :country_code, :city, :zip, :latitude, :longitude, :workflow_state)
end
