# == Schema Information
#
# Table name: account_executives
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AccountExecutive < ApplicationRecord
  include BackendUser

  has_many :management_clients
  has_many :property_clients
end
