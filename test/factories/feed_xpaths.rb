# == Schema Information
#
# Table name: feed_xpaths
#
#  id         :integer          not null, primary key
#  xpath      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :feed_xpath do
    xpath "MyString"
  end
end
