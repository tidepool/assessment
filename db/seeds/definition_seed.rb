class DefinitionSeed 
  include SeedsHelper

  def create_seed
    puts "Seeding the definition and assessment"
    # Load the default stages JSON file

    assessment_path = File.expand_path('../../assessment.json', __FILE__)
    definition = Definition.first 
    modified = check_if_inputs_modified(definition, assessment_path)
    
    if (modified)
      puts "Definition modified, creating new..."
      stages = IO.read(assessment_path)
      parsed_stages = JSON.parse stages 

      name = "Baseline Assessment"
      instructions = "This test assesses your personality based on the Big 5 personality types. Please take a moment to take this test."
      end_remarks = "Congratulations. Please take a moment to register!"

      if definition.nil?
        definition = Definition.create!(name: name, 
                                    stages: parsed_stages,
                                    instructions: instructions,
                                    end_remarks: end_remarks)
        # assessment = Assessment.create!(date_taken: "2012-12-23 18:05:01")
        # assessment.definition = definition
      else
        definition.stages = parsed_stages
        definition.name = name
        definition.instructions = instructions
        definition.end_remarks = end_remarks
        definition.save!
      end
    end
  end
end