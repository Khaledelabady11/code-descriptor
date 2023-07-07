require 'net/http'
require 'uri'
require 'base64'
require 'json'

class ImgurUploader
  BASE_URL = 'https://api.imgur.com/3/upload.json'

  def self.upload(image_paths)
    images_data = []

    Array(image_paths).each do |image_path|
      image_data = Base64.encode64(File.read(image_path, mode: 'rb'))
      params = { image: image_data }
      uri = URI.parse(BASE_URL)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(uri.path)
      request['Authorization'] = ENV['IMGUR_ACCESS_TOKEN']
      request.set_form_data(params)
      response = https.request(request)
      images_data << JSON.parse(response.body)
    end

    images_data
  end
end
