class ImageRankAnalyzer
  attr_reader :images, :start_time, :end_time, :final_rank, :stage

  def initialize(events)
    @images = []
    @final_rank = []
    process_events(events)
  end
  
  def calculate_result()
    elements = {}
    i = 0
    @images.each do |image|
      element_list = image["elements"].split(',')
      rank_multiplier = 5 - @final_rank[i]
      element_list.each do |element|
        elements[element] ||= 0
        elements[element] += rank_multiplier
      end
      i += 1
    end

    return elements
  end

  private

  def process_events(events)
    events.each do |entry|
      case entry["event_desc"]
      when "test_started"
        @stage = entry["stage"]
        @start_time = entry["record_time"] 
        @images = entry["image_sequence"]       
      when "test_completed"
        @end_time = entry["record_time"]
        @final_rank = entry["final_rank"]
      when "image_drag_start"
      when "image_ranked"
      when "image_rank_cleared"
      else
        puts "Wrong Event: #{entry}"
      end
    end
  end
end
