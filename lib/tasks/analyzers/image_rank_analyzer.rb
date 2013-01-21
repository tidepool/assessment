class ImageRankAnalyzer
  def initialize(events, definition)
    events.each do |entry|
      puts "#{entry.to_json}"
    end

    @definition = definition
    @start_time, @end_time, @image_sequence, @final_rank = process_events(events)
  end

  def process_events(events)
    images = []
    start_time = 0
    end_time = 0
    image_sequence = []
    final_rank = ""

    events.each do |entry|
      case entry["event_desc"]
      when "test_started"
        start_time = entry["record_time"] 
        image_sequence = entry["image_sequence"]       
      when "test_completed"
        end_time = entry["record_time"]
        final_rank = entry["final_rank"]
      when "image_drag_start"
      when "image_ranked"
      when "image_rank_cleared"
      end
    end
    return start_time, end_time, image_sequence, final_rank 
  end

  def calculate_result()

    return [
      { :element => "element1",
        :rank => 15 },
      { :element => "element2",
        :rank => 13 }
    ]
  end
end
