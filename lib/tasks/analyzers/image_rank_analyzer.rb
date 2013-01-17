class ImageRankAnalyzer
  def initialize(events, definition)
    @events = events
    @definition = definition
  end

  def calculate_result()
    @events.each do |entry|
      puts "#{entry.to_json}"
    end

    return [
      { :element => "element1",
        :rank => 15 },
      { :element => "element2",
        :rank => 13 }
    ]
  end
end
