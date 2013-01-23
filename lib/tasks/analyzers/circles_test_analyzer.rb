class CirclesTestAnalyzer
  attr_reader :start_time, :end_time, :circles, :radii, :start_coords, :self_circle

  def initialize(events)
    process_events events
  end

  def calculate_result()
    results = []
    self_circle_radius = @self_circle["size"] / 2.0
    self_circle_origin_x = @self_circle["left"] + self_circle_radius
    self_circle_origin_y = @self_circle["top"] + self_circle_radius     
    @circles.each do |circle|
      result = {}
      result[:trait1] = circle["trait1"]
      result[:trait2] = circle["trait2"]
      result[:size] = circle["size"]

      circle_radius = circle["width"] / 2.0

      result[:origin_x] = circle["left"] + circle_radius
      result[:origin_y] = circle["top"] + circle_radius
      result[:distance] = Math.sqrt((result[:origin_x] - self_circle_origin_x)**2 + (result[:origin_y] - self_circle_origin_y)**2)

      total_radius = circle_radius + self_circle_radius
      if result[:distance] >= total_radius
        # There is no overlap
        result[:overlap] = 0.0
      elsif result[:distance] <= self_circle_radius - circle_radius
        result[:overlap] = 1.0
      else
        result[:total_radius] = total_radius
        result[:circle_radius] = circle_radius
        result[:self_circle_radius] = self_circle_radius
        result[:overlap_distance] = total_radius - result[:distance]
        result[:overlap] = (total_radius - result[:distance]) / (2 * circle_radius)
      end
      results << result
    end

    return results
  end

  private
  def process_events(events)
    events.each do |entry|
      case entry["event_desc"]
      when "test_started"
        @start_time = entry["record_time"]
      when "move_circles_started"
      when "test_completed"
        @end_time = entry["record_time"]
        @circles = entry["circles"]
        @self_circle = entry["self_coord"]
      when "circle_start_move"
      when "circle_end_move"
      when "circle_resized"
      else
        puts "Wrong Event: #{entry}"
      end
    end
  end
end
