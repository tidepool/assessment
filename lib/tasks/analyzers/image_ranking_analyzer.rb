class ImageRankingAnalyzer
  def initialize(events, definition)
    @events = events
    @definition = definition
  end

  def calculate_result()
    @events.each do |entry|
      puts "#{entry}"
    end

    return [
      { :element => "element1",
        :rank => 15 },
      { :element => "element2",
        :rank => 13 }
    ]
  end
end
