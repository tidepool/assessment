require 'spec_helper'
require File.expand_path('../../load_tasks', __FILE__)

describe "Circles Test Analyzer" do 
  before(:all) do
    events_json = IO.read(File.expand_path('../../fixtures/event_log.json', __FILE__))
    events = JSON.parse(events_json).find_all { |event| event['module'] == 'circles_test'}
    @analyzer = CirclesTestAnalyzer.new(events)
    definition_json = IO.read(Rails.root.join('db', 'assessment.json'))
    @definition = JSON.parse definition_json

    @NUM_OF_LEVELS = 5
    @GROW_BY = 12
    @CIRCLE_SIZE = 156
  end

  it "should record the test start time with test start date 2013" do
    # Do a quick reality check
    # Note: JS time is reported in ms, Ruby is in sec for Epoch time
    start_time = Time.at(@analyzer.start_time/1000)
    # TODO: This test will start failing in 2013
    start_time.year.should equal(2013)
  end

  it "should record the test end time and greater than start_time" do    
    start_time = Time.at(@analyzer.start_time/1000)    
    end_time = Time.at(@analyzer.end_time/1000)
    (end_time - start_time).should be > 0
  end

  it "should have the right sizes for circles" do
    circles = @analyzer.circles
    circles.each do |circle|
      delta = (@NUM_OF_LEVELS - 1 - circle["size"]) * @GROW_BY
      correct_size = @CIRCLE_SIZE - delta
      correct_size.should == circle["width"]
    end
  end

  describe "Calculations" do
    before(:all) do
      events_json = <<JSONString
[
  {"event_type":"0","module":"circles_test","stage":3,"record_time":1358927109277,"event_desc":"test_started","assessment_id":340,"user_id":21},
  {"event_type":"0","module":"circles_test","stage":3,"record_time":1358927182747,"event_desc":"move_circles_started","circles":[{"trait1":"self-disciplined","trait2":"persistent","size":2,"changed":true,"moved":false,"top":130,"left":145,"width":132,"height":132,"textMarginTop":33,"sliderMarginLeft":38},{"trait1":"anxious","trait2":"dramatic","size":0,"changed":true,"moved":false,"top":142,"left":387,"width":108,"height":108,"textMarginTop":21,"sliderMarginLeft":26},{"trait1":"curious","trait2":"cultured","size":1,"changed":true,"moved":false,"top":271,"left":266,"width":120,"height":120,"textMarginTop":27,"sliderMarginLeft":32},{"trait1":"sociable","trait2":"adventurous","size":4,"changed":true,"moved":false,"top":388,"left":133,"width":156,"height":156,"textMarginTop":45,"sliderMarginLeft":50},{"trait1":"cooperative","trait2":"friendly","size":3,"changed":true,"moved":false,"top":394,"left":369,"width":144,"height":144,"textMarginTop":39,"sliderMarginLeft":44}],"assessment_id":340,"user_id":21},
  {"event_type":"0","module":"circles_test","stage":3,"record_time":1358927310488,"event_desc":"test_completed","circles":[{"trait1":"self-disciplined","trait2":"persistent","size":2,"changed":true,"moved":true,"top":209,"left":335,"width":132,"height":132,"textMarginTop":33,"sliderMarginLeft":38},{"trait1":"anxious","trait2":"dramatic","size":0,"changed":true,"moved":true,"top":283,"left":884,"width":108,"height":108,"textMarginTop":21,"sliderMarginLeft":26},{"trait1":"curious","trait2":"cultured","size":1,"changed":true,"moved":true,"top":165,"left":627,"width":120,"height":120,"textMarginTop":27,"sliderMarginLeft":32},{"trait1":"sociable","trait2":"adventurous","size":4,"changed":true,"moved":true,"top":68,"left":923,"width":156,"height":156,"textMarginTop":45,"sliderMarginLeft":50},{"trait1":"cooperative","trait2":"friendly","size":3,"changed":true,"moved":true,"top":376,"left":733,"width":144,"height":144,"textMarginTop":39,"sliderMarginLeft":44}],"self_coord":{"top":138,"left":693,"size":386},"assessment_id":340,"user_id":21}
]
JSONString
      events = JSON.parse(events_json)
      @analyzer = CirclesTestAnalyzer.new(events)
      @results = @analyzer.calculate_result
    end

    it "should have one fully overlapped circle with self circle" do
      overlapped = @analyzer.overlapped_circles(1.0)
      overlapped.length.should == 1
      overlapped[0][:trait1].should == "anxious"
    end

    it "should have one no-overlapped circle with self circle" do
      overlapped = @analyzer.overlapped_circles(0.0)
      overlapped.length.should == 1
      overlapped[0][:trait1].should == "self-disciplined"      
    end

    it "should have one overlapped circle between 50% - 100%" do
      overlapped = @analyzer.overlapped_circles(0.5, 1.0)
      overlapped.length.should == 1
      overlapped[0][:trait1].should == "cooperative"      
    end

    it "should have one overlapped circle between 0% - 50%" do
      overlapped = @analyzer.overlapped_circles(0.0, 0.5)
      overlapped.length.should == 2
      traits = overlapped.find_all { |result| result[:trait1] == "sociable" }
      traits[0][:trait1].should == "sociable"  
    end

    it "should find the closest circle to self circle" do
      closest_circle = @analyzer.closest_circle

      closest_circle[:trait1].should == "anxious"
    end

    it "should find the furthest circle to self circle" do
      furthest_circle = @analyzer.furthest_circle

      furthest_circle[:trait1].should == "self-disciplined"
    end
  end
end