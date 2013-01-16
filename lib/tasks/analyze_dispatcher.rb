Dir[Dir.expand_path('./analyzers', __FILE__)].each {|file| require file }
Dir[Dir.expand_path('../aggregators', __FILE__)].each {|file| require file }

class AnalyzeDispatcher
  def initialize(definition)
    @definition = definition
  end

  def analyze(user_events)
    modules = sort_events_to_modules(user_events)

    # Analyze events per module with their corresponding analyzer
    raw_results = raw_results(modules)

    # Aggregate results of all occurances of each module
    aggregate_results = aggregate_results(raw_results)
    { :raw_results => raw_results, :aggregate_results => aggregate_results}
  end

  def sort_events_to_modules(user_events)
    # Collect all events for each module
    modules = {}
    user_events.each do |user_event_json|
      user_event = JSON.parse user_event_json
      modules[user_event.module] = [] unless modules.has_key?(user_event.module)        
      modules[user_event.module] << user_event
    end  
    modules   
  end

  def raw_results(modules)
    modules.each do |key, events|
      klass_name = "#{key.camelize}Analyzer"
      begin
        analyzer = klass_name.constantize.new(events, @definition)
        raw_result = analyzer.calculate_result
        raw_results << { :module_name => key, :raw_result => raw_result }
      rescue Exception => e

      end
    end
  end

  def aggregate_results(raw_results)
    aggregate_results = []
    raw_results.each do |entry|
      klass_name = "#{entry.module_name}Aggregator"
      begin
        aggregator = klass_name.constantize.new
        aggregate_result = aggregator.calculate_result(entry.raw_result)
        aggregate_results << { :module_name => entry.module_name, :aggregate_result => aggregate_result }
      rescue Exception => e
        
      end
    end
  end
end

