class Organization < ApplicationRecord
  
  belongs_to :user
  belongs_to :broadband_type
  after_create :generate_access_code

  def generate_access_code
    self.access_code = rand.to_s[2..7]
    self.save
  end

end
