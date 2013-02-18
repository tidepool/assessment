require 'spec_helper'
require File.expand_path('../../load_tasks', __FILE__)

describe 'Reaction Time Aggregator' do
  before(:all) do
    #definition_json = IO.read(Rails.root.join('db', 'assessment.json'))
    #@definition = JSON.parse definition_json
    rt_raw_results_json =  IO.read(File.expand_path('../../fixtures/reaction_time_raw_results.json', __FILE__))
    @rt_raw_results = JSON.parse rt_raw_results_json, :symbolize_names => true
    @aggregator = ReactionTimeAggregator.new(@rt_raw_results, nil)
  end

  it 'should calculate the aggregate results from raw' do
    result = @aggregator.calculate_result
    result[:red][:total_clicks].should == 3
    result[:red][:total_clicks_with_threshold].should == 0
    result[:red][:total_correct_clicks_with_threshold].should == 0
    result[:red][:average_time].should == (3208 + 585)/2
    result[:red][:average_time_with_threshold].should == 0
    result[:red][:average_correct_time_to_click].should == 0
  end
end