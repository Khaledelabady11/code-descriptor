class Post < ApplicationRecord

  validates :title, presence: true
  validates :description, presence: true
  validates :keywords, presence: true

  has_many :comments, dependent: :destroy
  has_one :user


end
