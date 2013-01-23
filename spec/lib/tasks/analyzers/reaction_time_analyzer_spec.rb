require 'spec_helper'
require File.expand_path('../../load_tasks', __FILE__)

describe "Reaction Time Analyzer: " do 
  describe "Simple Reaction Time Test: " do 
    before(:all) do
      events_json = IO.read(File.expand_path('../../fixtures/event_log.json', __FILE__))
      events = JSON.parse(events_json).find_all { |event| event['module'] == 'reaction_time' && event['sequence_type'] == 'simple'}
      @analyzer = ReactionTimeAnalyzer.new(events)
    end

    it "should record number of clicks for yellow with no threshold" do
      clicks, average_time = @analyzer.clicks_and_average_time("yellow")
      clicks.should equal(10)
    end

    it "should record number of clicks on yellow where time is less than 200ms" do
      clicks, average_time = @analyzer.clicks_and_average_time("yellow", 200)
      clicks.should equal(0)
    end

    it "should calculate the time to click after red is shown" do
      clicks, average_time = @analyzer.clicks_and_average_time("red")
      average_time.should equal(47)        
    end

    it "should calculate the final result of the test" do
      pending "Add the test case here"    
    end 
  end

  describe "Complex Reaction Time Test" do
    before(:all) do
      events_json = IO.read(File.expand_path('../../fixtures/event_log.json', __FILE__))
      @events = JSON.parse(events_json).find_all { |event| event['module'] == 'reaction_time' && event['sequence_type'] == 'complex'}
    end

  end
end