json.partial! 'post', post: @post
json.comments @post.comments do |comment|
  json.id comment.id
  json.body comment.body
end
