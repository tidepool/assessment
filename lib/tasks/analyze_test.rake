require 'redis'
require 'json'
require 'debugger'
require File.expand_path('../analyze_dispatcher', __FILE__)

ACTION_EVENT_QUEUE = 'action_events'
MAX_NUM_EVENTS = 1000

desc "Analyze Test"
task :analyze_test => :environment do |t|
  puts "analyze running"
  # debugger
  $redis_analyze.subscribe(ACTION_EVENT_QUEUE) do |on|
    on.message do |channel, msg|
      data = JSON.parse(msg)
      puts "Message received at ##{channel} - [#{data['user_id']}]: #{data['assessment_id']}"

      user = User.find(data['user_id'])
      assessment = Assessment.find(data['assessment_id'])
      key = "user:#{data['user_id']}:test:#{data['assessment_id']}"
      user_events = $redis.lrange(key, 0, MAX_NUM_EVENTS)
      analyze_dispatcher = AnalyzeDispatcher.new(assessment.definition)
      results = analyze_dispatcher.analyze(user_events)
      assessment.score = "Booyah"
      assessment.save
    end
  end
  puts "analyze finished"
end