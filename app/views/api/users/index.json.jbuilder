json.status :ok
json.posts @users do |user|
  json.partial! 'user', user: user
end
