class ChatgptService
  include HTTParty

  attr_reader :api_url, :options, :model, :message

  def initialize(post ,body, model = 'gpt-3.5-turbo')
    api_key = Rails.application.credentials.chatgpt_api_key
    @options = {
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{api_key}"
      }
    }
    @api_url = 'https://api.openai.com/v1/chat/completions'
    @model = model
    instruction = "just explain this code"
    @message = instruction + body
    @post = post
  end

  def call
    body = {
      model: @model,
      messages: [{ role: 'user', content: message }]
    }
    response = HTTParty.post(api_url, body: body.to_json, headers: options[:headers], timeout: 80)
    raise CustomException, response['error']['message'] unless response.code == 200

    description = response['choices'][0]['message']['content']
    create_article(description)
    description
  end

  class CustomException < StandardError; end

  class << self
    def call(message, model = 'gpt-3.5-turbo')
      new(message, model).call
    end
  end

  private

  def create_article(description)
    return unless @post.present?

    article_repo = ArticleRepo.new(@post, description)
    article_repo.create_article
  end
end

