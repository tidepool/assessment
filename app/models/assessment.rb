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
  serialize :event_log, JSON
  serialize :intermediate_results, JSON
  serialize :stages, JSON
  
  attr_accessible :date_taken, :score, :raw_event_url, :status, :stages, :event_log, :intermediate_results
  belongs_to :definition
  belongs_to :user

end
