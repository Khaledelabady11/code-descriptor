module Api
  class PostsController < ApplicationController
    before_action :authorize_request , only: [:create,:destory]
    skip_before_action :verify_authenticity_token


    def index
      @posts = Post.includes(:user,:attachments,:likes,:comments).order(created_at: :desc).paginate(page: params[:page], per_page: 8)
      render 'api/posts/index', formats: :json
    end

    def show
      @post = Post.find(params[:id])
      render 'api/posts/show', formats: :json
    end
    def myposts
      @posts = Post.includes(:user, :likes).order(id: :desc).where(user_id: @current_user.id)
      render 'api/posts/myposts' , formats: :json
    end

    def new
      @post = Post.new
    end

    def create
      @post = Post.new(post_params)
        if @post.save
          if params[:attachment].present?
            response = ImgurUploader.upload(params[:attachment].tempfile.path)
            create_attachment_for_post(@post, response)
            extracted_text = ImageOcrService.perform_ocr(response['data']['link'])
            @post.update(extracted_text: extracted_text)
            CreateArticleJob.perform_later(@post)
          end
        render json: @post , status: :created
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
    end


    def destroy
      @post = Post.find(params[:id])
      @post.destroy
      render json: { message: 'Post deleted successfully' }
    end

    private

    def post_params
      params.require(:post).permit(:title, :keywords).merge(user_id: @current_user.id)
    end

    def create_attachment_for_post(post, response)
      resource_id = response['data']['id']
      resource_type = response['data']['type']
      resource_url = response['data']['link']
      width = response['data']['width']
      height = response['data']['height']

      attachment = AttachmentRepo.new(post, response, resource_id, resource_type, resource_url, width.to_s, height.to_s)
      attachment.create_attachment
    end

  end
end
