module RecordEvent
	ACTION_EVENT_QUEUE = 'action_events'

	def record
		case @event_type.to_i
		when UserEvent::ANALYSIS_EVENT
			save_in_store
		when UserEvent::ACTION_EVENT
			publish_to_queue
		else
			# logger.info("Unknown Event Type: #{self.event_data}")
		end
	end

	private

	def save_in_store
		$redis.rpush(key, @event_data)
	end

	def publish_to_queue
		$redis.publish(ACTION_EVENT_QUEUE, @event_data)
	end

	def key
		"user:#{self.user_id}:test:#{self.assessment_id}"
	end
end
