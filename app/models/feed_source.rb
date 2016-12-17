# == Schema Information
#
# Table name: feed_sources
#
#  id         :integer          not null, primary key
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FeedSource < ApplicationRecord
  has_many :feeds
  has_one :field_path_mapping

  after_create :create_field_path_mapping

  def self.for_url(url)
    self.where(url: url).first_or_create!
  end

  def import_feed
    xml_doc = import_xml_from_url
    self.feeds.create(raw_xml: xml_doc, xpaths:  xpaths_for_xml_doc(xml_doc).sort)
  end

  # Get a most recent list of all the xpaths of this feed source.
  def xpaths
    self.feeds.last.xpaths
  end

  # Imports xml for the registered source url.
  private def import_xml_from_url
    # http://www.nokogiri.org/tutorials/parsing_an_html_xml_document.html#from_the_internets
    Nokogiri::XML(open(url)) { |config| config.strict.nonet.noblanks }
  end

  # Generates an array of all the xpath from a Nokogiri-parsed document.
  # Duplicate xpaths will be removed and array indices will be replaced with `[]`.
  private def xpaths_for_xml_doc(xml_doc)
    # http://stackoverflow.com/a/15692699/3837223
    xml_doc.xpath('//*').map { |node| node.path.gsub(/\[\d*\]/, "[]") }.uniq
  end
end
