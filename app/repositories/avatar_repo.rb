class AvatarRepo
  def initialize(user, raw_response, resource_id, resource_type, resource_url)
    @user = user
    @raw_response = raw_response
    @resource_id = resource_id
    @resource_type = resource_type
    @resource_url = resource_url
  end

  def create
    avatar = @user.build_avatar(
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
