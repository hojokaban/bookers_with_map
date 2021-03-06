class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  include JpPrefecture
  jp_prefecture :prefecture, method_name: :pref

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  attachment :profile_image

  validates :name, length: {in: 2..20}
  validates :introduction, length: {maximum: 50}

  after_create :address


  def follow(user)
    following << user
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    following.include?(user)
  end

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  def address
    self.address = self.prefecture + self.city + self.street
  end

end
