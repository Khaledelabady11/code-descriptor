json.status :ok
json.posts @posts do |post|
  json.partial! 'post', post: post
end
