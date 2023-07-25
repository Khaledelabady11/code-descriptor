json.id post.id
json.title post.title
json.content post.extracted_text
json.attachment do
  json.image post.attachments.first&.resource_url
  json.image_width post.attachments.first&.width
  json.image_height post.attachments.first&.height
end
json.user do
  json.user_name post.user.username
end
json.comments_count post.comments.count

