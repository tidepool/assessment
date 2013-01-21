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

class Assessment < ActiveRecord::Base
  attr_accessible :date_taken, :score, :raw_event_url, :status
  belongs_to :definition
  belongs_to :user

  
end
