class Post < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 255 }
  
  has_many :favorites, dependent: :destroy
  has_many :fav_users, through: :favorites, source: :user,dependent: :destroy
  
  has_many :comments,dependent: :destroy
end
