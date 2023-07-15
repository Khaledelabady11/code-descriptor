class ArticleRepo
  def initialize(post, description)
    @post = post
    @description = description
  end

  def create_article
    return unless @post.present?

    article = @post.build_article(description: @description)
    if article.save
      article
    else
      puts "Failed to create the article: #{article.errors.full_messages.join(', ')}"
      nil
    end
  end
end
