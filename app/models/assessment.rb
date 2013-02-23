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
  serialize :aggregate_results, JSON

  attr_accessible :date_taken, :score, :stages, :event_log, :intermediate_results, :stage_completed,
                  :aggregate_results, :results_ready, :big5_dimension, :holland6_dimension, :emo8_dimension
  belongs_to :definition
  belongs_to :user
  belongs_to :profile_description

  def self.create_with_definition_and_user(definition, user)
    create! do |assessment|
      assessment.definition = definition
      assessment.stages = definition.stages_from_stage_definition
      assessment.user = user
      assessment.date_taken = DateTime.now
      assessment.results_ready = false
      assessment.stage_completed = -1
    end
  end

end
