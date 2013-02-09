require 'redis'
require 'json'
require File.expand_path('../analyze_dispatcher', __FILE__)

ACTION_EVENT_QUEUE = 'action_events'
MAX_NUM_EVENTS = 10000

desc "Analyze Test"
task :analyze_test => :environment do |t|
  puts "analyze running"

  $redis_analyze.subscribe(ACTION_EVENT_QUEUE) do |on|
    on.message do |channel, msg|
      data = JSON.parse(msg)
      puts "Message received at ##{channel} - [#{data['user_id']}]: #{data['assessment_id']}"

      assessment = Assessment.find(data['assessment_id'])
      key = "user:#{data['user_id']}:test:#{data['assessment_id']}"
      user_events_json = $redis.lrange(key, 0, MAX_NUM_EVENTS)
      
      assessment.event_log = user_events_json
      if Rails.env.development? || Rails.env.test? 
        #date = DateTime.now
        # stamp = date.strftime("%Y%m%d_%H%M")
        log_file_path = Rails.root.join('spec', 'lib', 'tasks', "fixtures", "event_log.json")
        File.open(log_file_path, "w+") do |file|
          output = "[\n" 
          user_events_json.each { |event| output += "#{event},\n" }
          output.chomp!(",\n")
          output += "\n]"
          file.write output  
        end
      end
      analyze_dispatcher = AnalyzeDispatcher.new(assessment.definition.stages)
      
      user_events = []
      user_events_json.each do |user_event| 
        user_events << JSON.parse(user_event)
      end
      results = analyze_dispatcher.analyze(user_events)
      assessment.intermediate_results = results[:raw_results]
      assessment.aggregate_results = results[:aggregate_results]
      assessment.big5_dimension = results[:big5_score]
      assessment.holland6_dimension = results[:holland6_score]
      #assessment.emo8_dimension = results[:emo8_score]
      assessment.profile_description = ProfileDescription.where('big5_dimension = ? AND holland6_dimension = ?', assessment.big5_dimension, assessment.holland6_dimension).first
      assessment.results_ready = true
      assessment.save
    end
  end
  puts "analyze finished"
end