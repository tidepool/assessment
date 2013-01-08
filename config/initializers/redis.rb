$redis = Redis.new(:host => ENV["REDIS_HOST"], :port => ENV["REDIS_PORT"])
# $redis_analyze will subscribe to the ACTION messages 
# DO NOT use $redis_analyze for anything other than subscribing, 
# You will otherwise get an error: ERR only (P)SUBSCRIBE / (P)UNSUBSCRIBE / QUIT allowed in this context
$redis_analyze = Redis.new(:timeout => 0, :host => ENV["REDIS_HOST"], :port => ENV["REDIS_PORT"])
