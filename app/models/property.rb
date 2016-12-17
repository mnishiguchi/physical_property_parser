# == Schema Information
#
# Table name: properties
#
#  id             :integer          not null, primary key
#  marketing_name :string
#  website        :string
#  description    :text
#  contact_email  :string
#  contact_phone  :string
#  street         :string
#  city           :string
#  state          :string
#  zip            :string
#  latitude       :float
#  longitude      :float
#  pet_dog        :json
#  pet_cat        :json
#  amenities      :json
#  feed_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Property < ApplicationRecord
  strip_attributes

  has_one :feed_property, dependent: :destroy
  belongs_to :feed

  has_many :floorplans

  scope :by_city_state, ->(q) {
    where("city ilike ? OR state ilike ? OR zip ilike ?",
          "%#{q}%", "%#{q}%", "%#{q}%")
  }

  def full_address
    "#{street}, #{city}, #{state} #{zip}"
  end
end
