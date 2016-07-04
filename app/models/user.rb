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

  before_save :set_default_role

  validates :provider, presence: true
  validates :uid, presence: true
  validates :name, presence: true


  def role_symbols
    self[:roles].map(&:to_sym)
  end

  private ####################

  def set_default_role
    self.roles = (self.roles << Role::DEFAULT_ROLE).uniq
  end

end
