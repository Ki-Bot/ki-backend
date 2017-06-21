class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :auth_token, uniqueness: true

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token 32
    end while self.class.exists?(auth_token: auth_token)
  end

end
