class OpeningHourSerializer < ActiveModel::Serializer
  attributes :id, :day, :from, :to, :closed
  def from
    object.from.to_s(:time)
  end
  def to
    object.to.to_s(:time)
  end
end
