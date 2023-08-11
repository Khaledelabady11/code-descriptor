json.status :ok
json.partial! 'message'
json.user do
    json.partial! 'user', user: @user
end
