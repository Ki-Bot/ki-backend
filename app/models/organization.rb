class Organization < ApplicationRecord
  
  belongs_to :user
  after_create :generate_access_code

  def generate_access_code
    self.access_code = rand.to_s[2..5]
    self.save
  end

end
