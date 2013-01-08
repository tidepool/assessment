class Analyze
  def self.calculate_result(user, assessment, user_events)
    # Do the calculations

    # Iterate over events
    puts "Events"
    puts "-------"
    user_events.each do |user_event|
      puts "#{user_event}"
    end

    # Save the score
    assessment.score = "COOL DUDE"
    assessment.save
  end
end