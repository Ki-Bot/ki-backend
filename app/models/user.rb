class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :auth_token, uniqueness: true
  validates :name, presence: true

  has_many :points
  has_many :favorites, through: :points, source: :broadband

  before_create :generate_authentication_token!

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token 32
    end while self.class.exists?(auth_token: auth_token)
  end

  def set_favorite_point!(point)
    unless self.favorites.include? point
      self.favorites << point
    end
  end

  def has_favorite?(point)
    self.favorites.include? point
  end

  def remove_favorite_point!(point)
    self.favorites.delete point
  end

end
