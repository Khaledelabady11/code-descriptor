class Post < ApplicationRecord

  validates :title, presence: true
  validates :keywords, presence: true

  has_many :comments, dependent: :destroy
  belongs_to :user

  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments

  has_one :article

end
