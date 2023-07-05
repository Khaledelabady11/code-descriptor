class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
  has_many :posts, foreign_key: :user_id, dependent: :destroy
  has_many :comments, dependent: :destroy


  enum role: { user: 0, admin: 1 }, _default: :user

  def admin?
    role == 'admin'
  end
  
end
