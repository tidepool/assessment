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
      events_json = IO.read(File.expand_path('../../fixtures/event_log.json', __FILE__))
      events = JSON.parse(events_json).find_all { |event| event['module'] == 'circles_test'}
      analyzer = CirclesTestAnalyzer.new(events)
      @results = analyzer.calculate_result
    end

    it "should have one fully overlapped circle with self circle" do
      overlapped = @results.find_all { |result| result[:overlap] == 1.0 }
      overlapped.length.should == 1
      overlapped[0][:trait1].should == "anxious"
    end

    it "should have one no-overlapped circle with self circle" do
      overlapped = @results.find_all { |result| result[:overlap] == 0.0 }
      overlapped.length.should == 1
      overlapped[0][:trait1].should == "self-disciplined"      
    end

    it "should have one overlapped circle between 50% - 100%" do
      overlapped = @results.find_all { |result| result[:overlap] > 0.5 && result[:overlap] < 1.0 }
      overlapped.length.should == 1
      overlapped[0][:trait1].should == "cooperative"      
    end

    it "should have one overlapped circle between 0% - 50%" do
      overlapped = @results.find_all { |result| result[:overlap] > 0.0 && result[:overlap] < 0.5 }
      overlapped.length.should == 2
      traits = overlapped.find_all { |result| result[:trait1] == "sociable" }
      traits[0][:trait1].should == "sociable"  
    end

  end
end