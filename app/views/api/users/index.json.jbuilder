json.status :ok
json.users @users do |user|
  json.partial! 'user', user: user
end
