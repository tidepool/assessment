require 'spec_helper'
require File.expand_path('../../load_tasks', __FILE__)

describe ImageRankingAggregator, "Image Ranking Aggregator" do 
  before(:all) do
    definition_json = IO.read(Rails.root.join('db', 'assessment.json'))
    @definition = JSON.parse definition_json
  end

  describe "should load this test" do
    pending "Add the test case here"    
  end
end