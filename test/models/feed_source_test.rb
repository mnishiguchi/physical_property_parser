# == Schema Information
#
# Table name: feed_sources
#
#  id         :integer          not null, primary key
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "test_helper"

class FeedSourceTest < ActiveSupport::TestCase
  # def feed_source
  #   @feed_source ||= FeedSource.new
  # end
  #
  # def test_valid
  #   assert feed_source.valid?
  # end
end
