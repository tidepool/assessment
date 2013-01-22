class CirclesTestAnalyzer
  def initialize(events, definition)
    events.each do |entry|
      puts "#{entry.to_json}"
    end

    @events = events
    @definition = definition
    process_events(events)
  end

  def process_events(events)
    events.each do |entry|
      puts "#{entry.to_json}"

      case entry["event_desc"]
      when "test_started"
        @start_time = entry["record_time"]   
      when "move_circles_started"
        @sizes = entry["final_sizes"]     
      when "test_completed"
        @end_time = entry["record_time"]
        @circles = []
        entry["final_coords"].each do | coord |
          x, y = coord.split(":").map { |coord| coord.to_f / 2 }
          @circles << {x: x, y: y}    
        end
      end

    end
  end
  
  def calculate_result()

    return [
      { :trait1 => "self-disciplined",
        :trait2 => "persistent",
        :size => 1,
        :distance => 120,
        :overlap => 0.5
      }
    ]
  end
end
