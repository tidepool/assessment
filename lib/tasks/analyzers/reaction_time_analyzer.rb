class ReactionTimeAnalyzer
  attr_reader :start_time, :end_time, :test_type, :circles, :color_sequence 

  def initialize(events)
    @TIME_THRESHOLD = 200
    @circles = {}
    @start_time = 0
    @end_time = 0
    @test_type = 'simple'
    @color_sequence = []
    
    process_events events
  end

  # Raw results are returned for each stage:
  # {
  #   :test_type => 'simple' || 'complex'
  #   :test_duration  => 12220
  #   :red => {
  #             :total_clicks_with_threshold => 3,
  #             :total_clicks => 5,
  #             :average_time_with_threshold => 1230,
  #             :average_time => 232,
  #             :total_correct_clicks_with_threshold => 2,
  #             :average_correct_time_to_click => 1
  #           }
  #   :green => {
  #           }
  # }
  def calculate_result
    result = { 
      :test_type => @test_type, 
      :test_duration => @end_time - @start_time
    }
    
    @circles.each do |color, value|
      result[color.to_sym] = {}
      total_clicks_with_threshold, average_time_with_threshold = 
        clicks_and_average_time(color, @TIME_THRESHOLD)
      total_clicks, average_time =  clicks_and_average_time(color)
      total_correct_clicks_with_threshold, average_correct_time_to_click = 0, 0
      if @test_type == 'complex' and color == 'red'
        total_correct_clicks_with_threshold, average_correct_time_to_click = 
          clicks_and_average_time(color, @TIME_THRESHOLD, true)
      end              

      result[color.to_sym] = {
        :total_clicks_with_threshold => total_clicks_with_threshold, 
        :total_clicks => total_clicks,
        :average_time_with_threshold => average_time_with_threshold,
        :average_time => average_time,
        :total_correct_clicks_with_threshold => total_correct_clicks_with_threshold,
        :average_correct_time_to_click => average_correct_time_to_click
      }
    end
    result
  end

  def clicks_and_average_time(color, time_threshold=100000, only_expected=false)
    total_clicks = 0
    average_time = 0
    total_time = 0
    return 0, 0 unless @circles.has_key?(color)

    @circles[color].each do |key, value|
      time_to_click = value[:clicked_at] - value[:shown_at]
      if value[:clicked] and (time_to_click > 0 and time_to_click < time_threshold) 
        if only_expected
          if value[:expected]
            total_clicks += 1
            total_time += time_to_click
          end
        else
          total_clicks += 1
          total_time += time_to_click
        end
      end
    end
    average_time = total_time / total_clicks if total_clicks > 0
    return total_clicks, average_time
  end


  private
  def process_events(events)
    events.each do |entry|
      case entry['event_desc']
      when 'test_started'
        @test_type = entry['sequence_type']
        @start_time = entry['record_time']
        @color_sequence = entry['color_sequence'].map do |item|
          color, time_interval = item.split(':')
          {color: color, time_interval: time_interval}
        end 
      when 'test_completed'
        @end_time = entry['record_time']
      when 'circle_shown'
        color = entry['circle_color']

        # We are using a Hash instead of an Array
        # We will look for each sequence in the event processing later on
        @circles[color] ||= {}
        sequence_no = entry['sequence_no']
        @circles[color][sequence_no] = {
          :shown_at => entry['record_time'],
          :clicked => false,
          :clicked_at => 0, 
          :expected => true
        }
      when 'correct_circle_clicked'
        color = entry['circle_color']
        sequence_no = entry['sequence_no']
        @circles[color][sequence_no][:clicked] = true
        @circles[color][sequence_no][:clicked_at] = entry['record_time']
        @circles[color][sequence_no][:expected] = true
      when 'wrong_circle_clicked'
        color = entry['circle_color']
        sequence_no = entry['sequence_no']
        @circles[color][sequence_no][:clicked] = true
        @circles[color][sequence_no][:clicked_at] = entry['record_time']
        @circles[color][sequence_no][:expected] = false
      else
        puts "Wrong Event: #{entry}"
      end
    end
  end
end
