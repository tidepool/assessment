tasks_path = Rails.root.join('lib', 'tasks', '*.rb').to_s
analyzers_path = Rails.root.join('lib', 'tasks', 'analyzers', '*.rb').to_s
aggregators_path = Rails.root.join('lib', 'tasks', 'aggregators', '*.rb').to_s

Dir[tasks_path].each {|file| require file }
Dir[analyzers_path].each {|file| require file }
Dir[aggregators_path].each {|file| require file }
