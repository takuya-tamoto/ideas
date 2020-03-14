class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :introduce, length: { maximum: 255 }
  validates_acceptance_of :agreement, allow_nil: false, on: :create
  
  has_secure_password
  
  has_many :posts, dependent: :destroy
  has_many :relationships,dependent: :destroy
  has_many :followings, through: :relationships, source: :follow,dependent: :destroy
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id',dependent: :destroy
  has_many :followers, through: :reverses_of_relationship, source: :user,dependent: :destroy
  
  has_many :favorites, dependent: :destroy
  has_many :fav_posts ,through: :favorites ,source: :post,dependent: :destroy
  
  has_many :comments, dependent: :destroy
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_posts
    Post.where(user_id: self.following_ids + [self.id])
  end
  
  def favorite(fav_post)
      self.favorites.find_or_create_by(post_id: fav_post.id)
  end  
    
  def unfavorite(fav_post)
    favorite = self.favorites.find_by(post_id: fav_post.id)
    favorite.destroy if favorite
  end
        
  def favorite?(fav_post)
    self.fav_posts.include?(fav_post)
  end
  
end