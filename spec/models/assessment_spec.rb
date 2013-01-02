# == Schema Information
#
# Table name: assessments
#
#  id         :integer          not null, primary key
#  definition :string(255)
#  date_taken :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Assessment do
  pending "add some examples to (or delete) #{__FILE__}"
end
