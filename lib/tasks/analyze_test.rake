require 'redis'
require 'json'
require 'debugger'
require File.expand_path('../analyze', __FILE__)

ACTION_EVENT_QUEUE = 'action_events'

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
      user_events = $redis.lrange(key, 0, 1000)
      Analyze.calculate_result(user, assessment, user_events)
    end
  end
  puts "analyze finished"
end