json.cache! ['show', user] do
  json.call(user, :id, :username, :name, :email)
end
