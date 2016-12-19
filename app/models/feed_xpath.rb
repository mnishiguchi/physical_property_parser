# == Schema Information
#
# Table name: feed_xpaths
#
#  id         :integer          not null, primary key
#  xpath      :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FeedXpath < ApplicationRecord
  validates :xpath, uniqueness: true
end
