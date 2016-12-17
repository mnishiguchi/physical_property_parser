# == Schema Information
#
# Table name: feed_sources
#
#  id         :integer          not null, primary key
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :feed_source do
    url "MyString"
    xpaths ""
    field_path_mapping ""
  end
end
