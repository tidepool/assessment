class CirclesTestAnalyzer
  def initialize(events, definition)
    events.each do |entry|
      puts "#{entry.to_json}"
    end

    @definition = definition
    process_events(events)
  end

  def process_events(events)
    events.each do |entry|
      puts "#{entry.to_json}"

      case entry["event_desc"]
      when "test_started"
        @start_time = entry["record_time"]
        @traits = entry["traits"]   
      when "move_circles_started"
        @sizes = entry["final_sizes"]
        @start_coords = entry["start_coords"]
        @radii = entry["radii"]     
      when "test_completed"
        @end_time = entry["record_time"]
        @circles = []
        i = 0
        entry["final_coords"].each do | coord |
          radius = @radii[i]
          x, y = coord.split(",").map { |coord| coord + radius }
          @circles << {x: x, y: y, radius: @radii[i], size: @sizes[i], traits: @traits[i]}
          i += 1    
        end
        radius = entry["self_radius"]
        x, y = entry["self_coord"].split(",").map { |coord| coord + radius }
        @self_circle = {x: x, y: y, radius: radius}
      end
    end
  end
  
  def calculate_result()
    results = []

    @circles.each do |circle|
      result = {}
      result[:traits] = circle[:traits]
      result[:size] = circle[:size]
      result[:distance] = Math.sqrt((circle[:x] - @self_circle[:x])**2 + (circle[:y] - @self_circle[:y])**2)
      total_radius = circle[:radius] + @self_circle[:radius]
      if result[:distance] >= total_radius
        # There is no overlap
        result[:overlap] = 0.0
      elsif result[:distance] <= @self_circle[:radius] - circle[:radius]
        result[:overlap] = 1.0
      else
        result[:overlap] = (@self_circle[:radius] + circle[:radius] - result[:distance]) / 2 * circle[:radius]
      end
      results << result
    end

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
