class Post < ApplicationRecord
  has_many :comments
  has_one :user
  
end
