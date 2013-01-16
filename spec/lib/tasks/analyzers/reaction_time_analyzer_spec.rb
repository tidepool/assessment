require 'spec_helper'
require File.expand_path('../../load_tasks', __FILE__)

describe ReactionTimeAnalyzer, "Reaction Time Analyzer" do 
  describe "Simple Reaction Time Test" do 
    before(:all) do
      events_json = IO.read(File.expand_path('../../fixtures/simple_reaction_events.json', __FILE__))
      @events = JSON.parse events_json
      definition_json = IO.read(Rails.root.join('db', 'assessment.json'))
      @definition = JSON.parse definition_json
    end

    it "should record number of clicks for yellow" do
      analyzer = ReactionTimeAnalyzer.new(@events, @definition)
      clicks = analyzer.number_of_clicks(:yellow)
      clicks.should equal(2)
    end

    it "should record number of clicks on yellow, green and red where time is less than 200ms" do
      pending "Add the test case here"
    end

    it "should calculate the time to click after red is shown" do
      analyzer = ReactionTimeAnalyzer.new(@events, @definition)
      time = analyzer.time_to_click(:red)
      time.should equal(500)        
    end

    it "should calculate the final result of the test" do
      pending "Add the test case here"    
    end 
  end

  describe "Complex Reaction Time Test" do
    before(:all) do
      events_json = IO.read(File.expand_path('../../fixtures/complex_reaction_events.json', __FILE__))
      @events = JSON.parse events_json
      definition_json = IO.read(Rails.root.join('db', 'assessment.json'))
      @definition = JSON.parse definition_json
    end

  end
end