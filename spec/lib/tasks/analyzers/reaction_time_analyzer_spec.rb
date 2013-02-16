require 'spec_helper'
require File.expand_path('../../load_tasks', __FILE__)

describe 'Reaction Time Analyzer: ' do
  describe 'Events are coming properly' do
    before(:all) do
      events_json = IO.read(File.expand_path('../../fixtures/event_log.json', __FILE__))
      events = JSON.parse(events_json).find_all { |event| event['module'] == 'reaction_time' && event['sequence_type'] == 'simple'}
      @analyzer = ReactionTimeAnalyzer.new(events)
      # definition_json = IO.read(Rails.root.join('db', 'assessment.json'))
      # @definition = JSON.parse definition_json
    end

    it 'should record the test start time with test start date 2013' do
      # Do a quick reality check
      # Note: JS time is reported in ms, Ruby is in sec for Epoch time
      start_time = Time.at(@analyzer.start_time/1000)
      # TODO: This test will start failing in 2013
      start_time.year.should equal(2013)
    end

    it 'should record the test end time and greater than start_time' do
      start_time = Time.at(@analyzer.start_time/1000)    
      end_time = Time.at(@analyzer.end_time/1000)
      (end_time - start_time).should be > 0
    end

    it 'should show all the colors in the color_sequence' do
      color_sequence = @analyzer.color_sequence
      circles = @analyzer.circles
      color_instances = {}
      color_sequence.each do | entry |
        color_instances[entry[:color]] = 0 if color_instances[entry[:color]].nil?
        color_instances[entry[:color]] += 1 
      end
      circles.each do |key, value|
        value.length.should == color_instances[key]
      end
    end

  end
  describe 'Simple Reaction Time Calculations: ' do
    before(:all) do
      events_json = <<JSONSTRING
[
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927074495,"event_desc":"test_started","color_sequence":["red:1325","green:762","yellow:625","red:1024","green:1435","red:787","yellow:1138","red:1049"],"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927075824,"event_desc":"circle_shown","circle_color":"red","sequence_no":0,"time_interval":1325,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927076571,"event_desc":"correct_circle_clicked","circle_color":"red","sequence_no":0,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927076590,"event_desc":"circle_shown","circle_color":"green","sequence_no":1,"time_interval":762,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927077217,"event_desc":"circle_shown","circle_color":"yellow","sequence_no":2,"time_interval":625,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927077681,"event_desc":"wrong_circle_clicked","circle_color":"yellow","sequence_no":2,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927078244,"event_desc":"circle_shown","circle_color":"red","sequence_no":3,"time_interval":1024,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927078923,"event_desc":"correct_circle_clicked","circle_color":"red","sequence_no":3,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927079682,"event_desc":"circle_shown","circle_color":"green","sequence_no":4,"time_interval":1435,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927080452,"event_desc":"wrong_circle_clicked","circle_color":"green","sequence_no":4,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927080472,"event_desc":"circle_shown","circle_color":"red","sequence_no":5,"time_interval":787,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927081240,"event_desc":"correct_circle_clicked","circle_color":"red","sequence_no":5,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927081613,"event_desc":"circle_shown","circle_color":"yellow","sequence_no":6,"time_interval":1138,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927082665,"event_desc":"circle_shown","circle_color":"red","sequence_no":7,"time_interval":1049,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927083155,"event_desc":"correct_circle_clicked","circle_color":"red","sequence_no":7,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":0,"sequence_type":"simple","record_time":1358927083157,"event_desc":"test_completed","sequence_no":7,"assessment_id":340,"user_id":21}
]
JSONSTRING
      events = JSON.parse(events_json)
      @analyzer = ReactionTimeAnalyzer.new(events)
      # definition_json = IO.read(Rails.root.join('db', 'assessment.json'))
      # @definition = JSON.parse definition_json
    end

    it 'should record number of clicks for yellow with no threshold' do
      clicks, average_time = @analyzer.clicks_and_average_time('yellow')
      clicks.should equal(1)
    end

    it 'should record number of clicks on yellow where time is less than 200ms' do
      clicks, average_time = @analyzer.clicks_and_average_time('yellow', 200)
      clicks.should equal(0)
    end

    it 'should record number of clicks on red where time is less than 500ms' do
      clicks, average_time = @analyzer.clicks_and_average_time('red', 500)
      clicks.should equal(1)
    end

    it 'should calculate the time to click after red is shown' do
      clicks, average_time = @analyzer.clicks_and_average_time('red')
      number_of_clicks = 0
      total_time = 0
      @analyzer.circles['red'].each do |circle|
        if (circle[1][:clicked])
          total_time += (circle[1][:clicked_at] - circle[1][:shown_at])
          number_of_clicks += 1
        end
      end  
      test_average_time = total_time / number_of_clicks if number_of_clicks > 0
      average_time.should == test_average_time        
    end

    it 'should calculate the final result of the test' do
      pending 'Add the test case here'
    end 
  end

  describe 'Complex Reaction Time Calculations' do
    before(:all) do
      events_json = <<JSONSTRING
[
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927084134,"event_desc":"test_started","color_sequence":["red:1158","red:758","yellow:588","green:848","yellow:709","green:875","green:831","red:1381","green:718","green:766","yellow:1161","red:857"],"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927085294,"event_desc":"circle_shown","circle_color":"red","sequence_no":0,"time_interval":1158,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927086054,"event_desc":"circle_shown","circle_color":"red","sequence_no":1,"time_interval":758,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927086062,"event_desc":"wrong_circle_clicked","circle_color":"red","sequence_no":1,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927086646,"event_desc":"circle_shown","circle_color":"yellow","sequence_no":2,"time_interval":588,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927087496,"event_desc":"circle_shown","circle_color":"green","sequence_no":3,"time_interval":848,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927088208,"event_desc":"circle_shown","circle_color":"yellow","sequence_no":4,"time_interval":709,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927088220,"event_desc":"wrong_circle_clicked","circle_color":"yellow","sequence_no":4,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927088930,"event_desc":"wrong_circle_clicked","circle_color":"yellow","sequence_no":4,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927089085,"event_desc":"circle_shown","circle_color":"green","sequence_no":5,"time_interval":875,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927089919,"event_desc":"circle_shown","circle_color":"green","sequence_no":6,"time_interval":831,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927091302,"event_desc":"circle_shown","circle_color":"red","sequence_no":7,"time_interval":1381,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927091898,"event_desc":"wrong_circle_clicked","circle_color":"red","sequence_no":7,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927092023,"event_desc":"circle_shown","circle_color":"green","sequence_no":8,"time_interval":718,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927092791,"event_desc":"circle_shown","circle_color":"green","sequence_no":9,"time_interval":766,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927093955,"event_desc":"circle_shown","circle_color":"yellow","sequence_no":10,"time_interval":1161,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927094816,"event_desc":"circle_shown","circle_color":"red","sequence_no":11,"time_interval":857,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927095378,"event_desc":"correct_circle_clicked","circle_color":"red","sequence_no":11,"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"reaction_time","stage":1,"sequence_type":"complex","record_time":1358927095380,"event_desc":"test_completed","sequence_no":11,"assessment_id":340,"user_id":21}
]
JSONSTRING
      @events = JSON.parse(events_json)
    end

  end
end