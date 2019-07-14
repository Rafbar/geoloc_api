json.cache_if! geolocation.resolved?, [geolocation.cache_key], expires_in: 3.minutes do
  json.call(geolocation, :key, :ip, :country_code, :city, :zip, :latitude, :longitude, :workflow_state)
end
