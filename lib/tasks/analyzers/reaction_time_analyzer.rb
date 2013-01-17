class ReactionTimeAnalyzer
  def initialize(events, definition)
    @events = events
    @definition = definition
  end

  def calculate_result()
    # Log out the events
    @events.each do |entry|
      puts "#{entry.to_json}"
    end

  end

  def number_of_clicks(color, time_threshold=10000)
    2
  end

  def time_to_click(color)
    500
  end
end
