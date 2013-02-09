require 'spec_helper'
require File.expand_path('../load_tasks', __FILE__)

describe 'Analyze Dispatcher' do
  before(:all) do
    events_json = IO.read(File.expand_path('../fixtures/event_log.json', __FILE__))
    @events = JSON.parse(events_json)
    stages_json = IO.read(Rails.root.join('db', 'assessment.json'))
    @stages = JSON.parse stages_json
    @analyze_dispatcher = AnalyzeDispatcher.new(@stages)
  end
  
  it 'should sort events into modules' do
    modules = @analyze_dispatcher.sort_events_to_modules(@events)
    modules.length.should == 8
  end

  it 'should generate raw results from modules' do
    modules = @analyze_dispatcher.sort_events_to_modules(@events)
    raw_results = @analyze_dispatcher.raw_results(modules)
    raw_results.length.should == 3
    raw_results['image_rank'].should_not be_nil
    raw_results['circles_test'].should_not be_nil
    raw_results['reaction_time'].should_not be_nil
    #(raw_results.keys.find_all { |key| key == 'image_rank'}).length.should == 1
  end

  it 'should generate aggregate results from raw results' do
    modules = @analyze_dispatcher.sort_events_to_modules(@events)
    raw_results = @analyze_dispatcher.raw_results(modules)
    aggregate_results = @analyze_dispatcher.aggregate_results(raw_results)
    aggregate_results.length.should == 3
  end

  it 'should analyze from saved events' do
    results = @analyze_dispatcher.analyze(@events)
    results[:raw_results].should_not be_nil
    results[:aggregate_results].should_not be_nil
    results[:big5_score].should_not be_nil
    results[:holland6_score].should_not be_nil
  end

  #describe 'Big5, Holland6 and Emo8 Calculations' do
  #  before(:all) do
  #    @aggregate_results = {
  #        image_rank: {
  #            Big5: {
  #                Openness: { average: 10 },
  #                Agreeableness: { average: 3 },
  #                Conscientiousness: { average: 8 },
  #                Extraversion: { average: 6 },
  #                Neuroticism: { average: 1 }
  #            }
  #        },
  #        circles_test: {
  #            Big5: {
  #                Openness: { average: 4 },
  #                Agreeableness: { average: 6 },
  #                Conscientiousness: { average: 2 },
  #                Extraversion: { average: 1 },
  #                Neuroticism: { average: 5 }
  #            },
  #            Holland6: {
  #                Realistic: { average: 8 },
  #                Artistic: { average: 12 },
  #                Social: { average: 4 },
  #                Enterprising: { average: 3 },
  #                Investigative: { average: 1 },
  #                Conventional: { average: 5 }
  #            }
  #        }
  #    }
  #    stages_json = IO.read(Rails.root.join('db', 'assessment.json'))
  #    @stages = JSON.parse stages_json
  #    @analyze_dispatcher = AnalyzeDispatcher.new(@stages)
  #  end
  #  it 'should calculate the Big5 score correctly' do
  #    dimension = @analyze_dispatcher.calculate_big5(@aggregate_results)
  #    dimension.should == 'High Openness'
  #  end
  #  it 'should calculate the Holland6 score correctly' do
  #    dimension = @analyze_dispatcher.calculate_holland6(@aggregate_results)
  #    dimension.should == 'Artistic'
  #  end
  #  it 'should have the correct profile description' do
  #    big5_dimension = @analyze_dispatcher.calculate_big5(@aggregate_results)
  #    holland6_dimension = @analyze_dispatcher.calculate_holland6(@aggregate_results)
  #
  #    profile = ProfileDescription.where('big5_dimension = ? AND holland6_dimension = ?', big5_dimension, holland6_dimension).first
  #    profile.should_not be_nil
  #    profile.name.should == 'The Different Drummer'
  #  end
  #end
end