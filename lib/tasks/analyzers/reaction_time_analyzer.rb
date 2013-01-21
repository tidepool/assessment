require 'debugger'

class ReactionTimeAnalyzer
  def initialize(events, definition)
    events.each do |entry|
      puts "#{entry.to_json}"
    end

    @definition = definition
    @circles, @start_time, @end_time, @test_type = process_events(events)
    @TIME_THRESHOLD = 200
  end

  def process_events(events)
    circles = {}
    start_time = 0
    end_time = 0
    test_type = "simple"

    events.each do |entry|
      puts "#{entry.to_json}"

      case entry["event_desc"]
      when "test_started"
        test_type = entry["sequence_type"]
        start_time = entry["record_time"]        
      when "test_completed"
        end_time = entry["record_time"]
      when "circle_shown"
        color = entry["circle_color"]
        if !circles.has_key?(color)
          circles[color] = {}
        end
        sequence_no = entry["sequence_no"]
        circles[color][sequence_no] = {
          :shown_at => entry["record_time"],
          :clicked => false,
          :clicked_at => 0, 
          :expected => true
        }
      when "correct_circle_clicked"
        color = entry["circle_color"]
        sequence_no = entry["sequence_no"]
        circles[color][sequence_no][:clicked] = true
        circles[color][sequence_no][:clicked_at] = entry["record_time"]
        circles[color][sequence_no][:expected] = true
      when "wrong_circle_clicked"
        color = entry["circle_color"]
        sequence_no = entry["sequence_no"]
        circles[color][sequence_no][:clicked] = true
        circles[color][sequence_no][:clicked_at] = entry["record_time"]
        circles[color][sequence_no][:expected] = false
      else
        puts "Wrong Event: #{entry}"
      end
    end
    return circles, start_time, end_time, test_type
  end

  def clicks_and_average_time(color, time_threshold=100000, only_expected=false)
    total_clicks = 0
    average_time = 0
    total_time = 0
    return 0, 0 if !@circles.has_key?(color)

    @circles[color].each do |key, value|
      time_to_click = value[:clicked_at] - value[:shown_at]
      if value[:clicked] and (time_to_click > 0 and time_to_click < time_threshold) 
        if (only_expected)
          if (value[:expected])
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

  def calculate_result()
    result = { 
      :test_type => @test_type, 
      :test_duration => @end_time - @start_time
    }
    
    @circles.each do |key, value|
      result[key] = {}
      total_clicks_with_threshold, average_time_with_threshold = 
        clicks_and_average_time(key, @TIME_THRESHOLD)
      total_clicks, average_time =  clicks_and_average_time(key)
      if @test_type == 'complex' and key = "red"
        total_correct_clicks_with_threshold, average_correct_time_to_click = 
          clicks_and_average_time(key, @TIME_THRESHOLD, true)
      end              

      result[key] = {
        :total_clicks_with_threshold => total_clicks_with_threshold, 
        :total_clicks => total_clicks,
        :average_time_with_threshold => average_time_with_threshold,
        :average_time => average_time,
        :total_correct_clicks_with_threshold => total_correct_clicks_with_threshold,
        :average_correct_time_to_click => average_correct_time_to_click
      }
    end
    return result
  end
end
