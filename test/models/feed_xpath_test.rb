# == Schema Information
#
# Table name: feed_xpaths
#
#  id         :integer          not null, primary key
#  xpath      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "test_helper"

describe FeedXpath do
  let(:feed_xpath) { FeedXpath.new }

  it "must be valid" do
    value(feed_xpath).must_be :valid?
  end
end
