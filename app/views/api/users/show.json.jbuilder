json.status :ok
json.user do
    json.partial! 'user', user: @user
end
