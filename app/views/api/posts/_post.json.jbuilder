json.id post.id
json.title post.title
json.images post.attachments do |attachment|
  json.url attachment.resource_url
end
json.image_content post.extracted_text
json.user_name post.user_id
