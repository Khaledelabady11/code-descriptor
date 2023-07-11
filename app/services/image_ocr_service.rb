
require 'open-uri'
require 'tempfile'
require 'uri'
require 'net/http'
class ImageOcrService

  def self.perform_ocr(image_url)
    begin
      uri = URI.parse(image_url)
      response = Net::HTTP.get_response(uri)

      tempfile = Tempfile.new(['image', '.png'])
      tempfile.set_encoding('ASCII-8BIT')
      tempfile.write(response.body)

      result = RTesseract.new(tempfile.path).to_s

      result
    ensure
      tempfile.close
      tempfile.unlink
    end

  end
end
