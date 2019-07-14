json.cache! ['show', user], expires_in: 3.minutes do
  json.call(user, :id, :username, :name, :email)
end
