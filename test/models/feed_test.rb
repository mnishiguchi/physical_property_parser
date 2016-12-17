# == Schema Information
#
# Table name: feeds
#
#  id             :integer          not null, primary key
#  raw_xml        :text             not null
#  xpaths         :string           not null, is an Array
#  feed_source_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require "test_helper"

class FeedTest < ActiveSupport::TestCase
  # def feed
  #   @feed ||= Feed.new
  # end
  #
  # def test_valid
  #   assert feed.valid?
  # end
end
