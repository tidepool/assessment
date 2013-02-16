class ReactionTimeAggregator
  def initialize(raw_results, stages)
    @raw_results = raw_results
    @stages = stages
  end

  # Raw results are coming in: (per each stage)
  # {
  #   :test_type => 'simple' || 'complex'
  #   :test_duration  => 12220
  #   :red => {
  #             :total_clicks_with_threshold => 3,
  #             :total_clicks => 5,
  #             :average_time_with_threshold => 1230,
  #             :average_time => 232,
  #             :total_correct_clicks_with_threshold => 2,
  #             :average_correct_time_to_click => 1
  #           }
  #   :green => {
  #           }
  # }
  def calculate_result
    aggregate_result = {}
    # Only looking at :red color
    colors = [:red]
    @raw_results.each do |result|
      colors.each do |color|
        aggregate_result[color] ||= {
            :total_clicks_with_threshold => 0,
            :total_clicks => 0,
            :total_correct_clicks_with_threshold => 0
        }
        aggregate_result[color][:total_clicks] += result[color][:total_clicks]
        aggregate_result[color][:total_clicks_with_threshold] += result[color][:total_clicks_with_threshold]
        aggregate_result[color][:total_correct_clicks_with_threshold] += result[color][:total_correct_clicks_with_threshold]
        aggregate_result[color][:average_time] += aggregate_result[color][:average_time]
        aggregate_result[color][:average_time_with_threshold] += aggregate_result[color][:average_time_with_threshold]
        aggregate_result[color][:average_correct_time_to_click] += aggregate_result[color][:average_correct_time_to_click]
      end
    end
    num_of_results = @raw_results.length
    if num_of_results != 0
      colors.each do |color|
        aggregate_result[color][:average_time] = aggregate_result[color][:average_time] / num_of_results
        aggregate_result[color][:average_time_with_threshold] = aggregate_result[color][:average_time_with_threshold] / num_of_results
        aggregate_result[color][:average_correct_time_to_click] = aggregate_result[color][:average_correct_time_to_click] / num_of_results
      end
    end
  end
end