require 'spec_helper'
require File.expand_path('../load_tasks', __FILE__)

describe "Analyze Dispatcher" do
  before(:all) do
    events_json = IO.read(File.expand_path('../fixtures/event_log.json', __FILE__))
    @events = JSON.parse(events_json)
    definition_json = IO.read(Rails.root.join('db', 'assessment.json'))
    @definition = JSON.parse definition_json
    @analyze_dispatcher = AnalyzeDispatcher.new(@definition)
  end
  
  it "should sort events into modules" do
    modules = @analyze_dispatcher.sort_events_to_modules(@events)
    modules.length.should == 4
  end

  it "should generate raw results from modules" do
    modules = @analyze_dispatcher.sort_events_to_modules(@events)
    raw_results = @analyze_dispatcher.raw_results(modules)
    raw_results.length.should == 3
    (raw_results.keys.find_all { |key| key == "image_rank"}).length.should == 1
  end

  it "should generate aggregate results from raw results" do
    modules = @analyze_dispatcher.sort_events_to_modules(@events)
    aggregate_results = @analyze_dispatcher.raw_results(modules)
    aggregate_results.length.should == 3

  end
end