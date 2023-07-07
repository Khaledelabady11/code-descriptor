module Api
  class PostsController < ApplicationController
    before_action :authorize_request, except: :show

    def new
      @post = Post.new
    end

    def create
      @post = Post.new(post_params)

      if @post.save
        upload_image
        render json: @post, status: :ok
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      @post = Post.find(params[:id])
    end

    private

    def post_params
      params.require(:post).permit(:title,:description,:keywords,:user_id)
    end

    def upload_image
      if params[:post][:attachment].present?
        attachments = Array(params[:post][:attachment])
        image_paths = attachments.map { |attachment| attachment.tempfile.path if attachment.present? }.compact
        response = ImgurUploader.upload(image_paths)
        response.each do |image_data|
          resource_id = image_data['data']['id']
          resource_type = image_data['data']['type']
          resource_url = image_data['data']['link']
          attachment_repo = AttachmentRepo.new(@post, response, resource_id, resource_type, resource_url)
          attachment_repo.create_attachment
        end
      end
    end
  end

end
