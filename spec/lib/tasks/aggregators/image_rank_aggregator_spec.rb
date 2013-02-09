require 'spec_helper'
require File.expand_path('../../load_tasks', __FILE__)

describe 'Image Rank Aggregator' do
  before(:all) do
    @current_analysis_version = '1.0'

    elements = {}
    Element.where(version: @current_analysis_version).each do |entry|
      elements[entry[:name]] = entry
    end
    raw_results = { 'animal' => 10, 'adult' => 5, 'alone' => 7, 'abstraction' => 15 }

    @aggregator = ImageRankAggregator.new(raw_results, {})
    @aggregator.elements = elements
  end

  it 'should calculate the Big 5 dimensions from elements' do
    result = @aggregator.calculate_result
    result[:Big5].should_not be_nil
    result[:Big5][:Extraversion][:weighted_total].should be_within(0.0005).of(0.0)
    result[:Big5][:Conscientiousness][:weighted_total].should be_within(0.0005).of(0.7370)
    result[:Big5][:Neuroticism][:weighted_total].should be_within(0.0005).of(0.6343)
    result[:Big5][:Openness][:weighted_total].should be_within(0.0005).of(0.0)
    result[:Big5][:Agreeableness][:weighted_total].should be_within(0.0005).of(-0.7048)
  end
end