Dir[File.expand_path('../analyzers/*.rb', __FILE__)].each {|file| require file }
Dir[File.expand_path('../aggregators/*.rb', __FILE__)].each {|file| require file }

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
    user_events.each do |user_event|
      module_name = "#{user_event['module']}:#{user_event['stage']}"
      modules[module_name] = [] unless modules.has_key?(user_event["module"])        
      modules[module_name] << user_event
    end  
    modules   
  end

  def raw_results(modules)
    raw_results = []
    modules.each do |key, events|
      module_name, stage = key.split(":")
      klass_name = "#{module_name.camelize}Analyzer"
      begin
        analyzer = klass_name.constantize.new(events)
        raw_result = analyzer.calculate_result()
        raw_results << { module_name: module_name, stage: stage, raw_result: raw_result }
      rescue Exception => e
         raise e 
      end
    end
    raw_results
  end

  def aggregate_results(raw_results)
    #TODO: FIX THIS, should take into account stages
    aggregate_results = []
    raw_results.each do |entry|
      puts "Raw Result = #{entry}"
      klass_name = "#{entry[:module_name].camelize}Aggregator"
      begin
        aggregator = klass_name.constantize.new(entry[:raw_result], @definition)
        aggregate_result = aggregator.calculate_result()
        aggregate_results << { :module_name => entry[:module_name], :aggregate_result => aggregate_result }
      rescue Exception => e
        raise e
      end
    end
  end
end

