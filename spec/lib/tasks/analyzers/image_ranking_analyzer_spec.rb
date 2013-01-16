require 'spec_helper'
require File.expand_path('../../load_tasks', __FILE__)

describe ImageRankingAnalyzer, "Image Ranking Analyzer" do 
  before(:all) do
    events_json = IO.read(File.expand_path('../../fixtures/image_ranking_events.json', __FILE__))
    @events = JSON.parse events_json
    definition_json = IO.read(Rails.root.join('db', 'assessment.json'))
    @definition = JSON.parse definition_json
  end
  
  describe "should load this test" do
      pending "Add the test case here"    
  end
end
