class OpeningHour < ApplicationRecord
  belongs_to :broadband

  def from
    self[:from].to_s(:time)
  end

  def to
    self[:to].to_s(:time)
  end
end
