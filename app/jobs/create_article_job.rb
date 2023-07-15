class CreateArticleJob < ApplicationJob
  queue_as :default

  def perform(post)
    ChatgptService.call(post,post.extracted_text)
  end
end
