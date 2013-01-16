class CirclesTestAnalyzer
  def initialize(events, definition)
    @events = events
    @definition = definition
  end

  def calculate_result()
    @events.each do |entry|
      puts "#{entry}"
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
