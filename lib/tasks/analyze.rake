require 'redis'
require 'json'
require File.expand_path('../analyze', __FILE__)

ACTION_EVENT_QUEUE = 'action_events'
$redis_analyze = Redis.new(:timeout => 0, :host => ENV["REDIS_HOST"], :port => ENV["REDIS_PORT"])

desc "Analyze Test"
task :analyze_test => :environment do |t|
  $redis_analyze.subscribe(ACTION_EVENT_QUEUE) do |on|
    on.message do |channel, msg|
      data = JSON.parse(msg)
      puts "##{channel} - [#{data['user_id']}]: #{data['assessment_id']}"

      user = User.find(data['user_id'])
      assessment = Assessment.find(data['assessment_id'])
      key = "user:#{data['user_id']}:test:#{data['assessment_id']}"
      user_events = $redis_analyze.lrange(key, 0, 1000)
      Analyze.calculate_result(user, assessment, user_events)
    end
  end
end