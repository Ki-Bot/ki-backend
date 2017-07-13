class OpeningHourSerializer < ActiveModel::Serializer
  attributes :id, :day, :from, :to, :closed
end
