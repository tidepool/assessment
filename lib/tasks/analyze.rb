class Analyze
  def self.calculate_result(user, assessment, user_events)
    # Do the calculations

    # Save the score
    assessment.score = "COOL DUDE"
    assessment.save
  end
end