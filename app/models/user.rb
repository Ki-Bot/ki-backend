# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  provider         :string
#  uid              :string
#  name             :string
#  oauth_token      :string
#  oauth_expires_at :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  roles            :string           default([]), is an Array
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :points
  has_many :favorites, through: :points, source: :broadband

  before_save :set_default_role

  # validates :provider, presence: true
  # validates :uid, presence: true
  # validates :name, presence: true


  def role_symbols
    self[:roles].map(&:to_sym)
  end

  def set_favorite_point(point)
    unless self.favorites.include? point
      self.favorites << point
    end
  end

  def has_favorite?(point)
    return true if self.favorites.include? point
    return false
  end

  def remove_favorite_point(point)
    self.favorites.delete(point)
  end

  private ####################

  def set_default_role
    self.roles = roles.delete_if(&:empty?)
    self.roles = (roles << Role::DEFAULT_ROLE).uniq
  end

end
