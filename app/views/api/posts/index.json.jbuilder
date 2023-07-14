json.posts @posts do |post|
  json.partial! 'post', post: post
  json.comments_count post.comments.count
end
