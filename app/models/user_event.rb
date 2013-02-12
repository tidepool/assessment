class UserEvent
	include RecordEvent
	extend ActiveModel::Naming
	include ActiveModel::Conversion
	def persisted?	
  	false
	end
	
	attr_accessor :user_id, :assessment_id, :event_type

	ANALYSIS_EVENT = 0
	ACTION_EVENT = 1

	def initialize(data)
		@user_id = data[:user_id]
		@assessment_id = data[:assessment_id]
		@event_type = data[:event_type]
		raise ArgumentError("Invalid Event #{data}") if @user_id.nil? || @assessment_id.nil? || event_type.nil? 
		@event_data = data
	end
end
