class AvatarRepo
  def initialize(content, raw_response, resource_id, resource_type, resource_url, width, height)
      @content = content
      @raw_response = raw_response
      @resource_id = resource_id
      @resource_type = resource_type
      @resource_url = resource_url
      @width = width
      @height = height
  end

  def create_avatar
    avatar = @content.build_avatar(
      raw_response: @raw_response,
      resource_id: @resource_id,
      resource_type: @resource_type,
      resource_url: @resource_url,
      width: @width,
      height: @height
    )
    avatar.save

  end
end
