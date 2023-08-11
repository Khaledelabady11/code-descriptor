json.status :ok
json.likes @likes.each do |like|
  json.user_name like.user.username
end

