class RecordEvents
  def initialize(events, assessment)
    @events = events
    @assessment = assessment
  end

  def record
    serialized_events = @events.to_json
    assessment.event_log = serialized_events
    assessment.save
  end
end