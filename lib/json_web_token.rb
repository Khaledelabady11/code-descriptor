class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
  
  class TokenError < StandardError; end
  class InvalidTokenError < TokenError; end

  def self.encode(payload, exp = 100.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    raise TokenError, "Token cannot be nil or empty." if token.nil? || token.empty?

    begin
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new(decoded)
    rescue JWT::DecodeError, JWT::ExpiredSignature
      raise InvalidTokenError, "Invalid token or token has expired."
    end
  end
end
