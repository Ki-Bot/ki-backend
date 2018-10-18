class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :auth_token, uniqueness: true
  # validates :name, presence: true

  has_many :points, dependent: :delete_all
  has_many :reviews, dependent: :delete_all
  has_many :favorites, through: :points, source: :broadband, dependent: :delete_all

  has_many :user_broadbands, dependent: :delete_all
  has_many :broadbands, through: :user_broadbands

  has_many :organizations, :dependent => :destroy

  before_create :generate_authentication_token!

  def generate_authentication_token!
    begin
      self.auth_token = [1,1,1,1,1,1].map!{|x| (0..9).to_a.sample}.join
    end while self.class.exists?(auth_token: self.auth_token)
  end

  def set_favorite_point!(point)
    unless self.favorites.include? point
      self.favorites << point
    end
  end

  def has_favorite?(point)
    self.favorites.include? point
  end

  def has_favorite_id?(id)
    self.favorites.map(&:id).include? id
  end

  def remove_favorite_point!(point)
    self.favorites.delete point
  end

  def self.custom_oauth(provider, uid, token, email, name, picture)
    where(provider: provider, uid: uid).first_or_create do |user|
      user.provider = provider
      user.uid      = uid
      user.oauth_token = token
      user.email = email
      user.name = name
      user.profile_picture = picture
      user.save!
    end

  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid      = auth.uid
      user.name     = auth.info.name
      user.email    = auth.info.email
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = auth.credentials.expires_at.present? ? Time.at(auth.credentials.expires_at) : ''
      user.save!
    end
  end

  def can_edit_broadband(broadband)
    broadbands.include?(broadband)
  end

end
