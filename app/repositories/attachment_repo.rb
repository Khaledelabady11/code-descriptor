class AttachmentRepo
  def initialize(content, raw_response, resource_id, resource_type, resource_url)
      @content = content
      @raw_response = raw_response
      @resource_id = resource_id
      @resource_type = resource_type
      @resource_url = resource_url
  end

  def create_attachment
      @content.attachments.create(
          raw_response: @raw_response,
          resource_id: @resource_id,
          resource_type: @resource_type,
          resource_url: @resource_url)
  end
end
