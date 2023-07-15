module Api
  class ArticlesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def show
      @article = Article.find_by(post_id: params[:post_id])
      if @article
        render 'api/articles/show' , formats: :json
      else
        render json: { error: 'Article not found' }, status: :not_found
      end
    end
  end
end
