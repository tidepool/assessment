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

      user = User.find(data['user_id'])
      assessment = Assessment.find(data['assessment_id'])
      key = "user:#{data['user_id']}:test:#{data['assessment_id']}"
      user_events = $redis.lrange(key, 0, MAX_NUM_EVENTS)
      
      assessment.event_log = user_events
      if Rails.env.development? || Rails.env.test? 
        date = DateTime.now
        stamp = date.strftime("%Y%m%d_%H%M")
        log_file_path = Rails.root.join('spec', 'lib', 'tasks', "fixtures", "event_log_#{stamp}.json")
        File.open(log_file_path, "w+") do |file| 
          user_events.each { |event| file.write("#{event}\n") } 
        end
      end
      analyze_dispatcher = AnalyzeDispatcher.new(assessment.definition)
      assessment.intermediate_results = analyze_dispatcher.analyze(user_events)

      assessment.save
    end
  end
  puts "analyze finished"
end