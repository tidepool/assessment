class DefinitionSeed 
  include SeedsHelper

  def create_seed
    puts 'Seeding the definitions'
    # Load the default stages JSON file
    Dir[File.expand_path('../definitions/*.json', __FILE__)].each do |path|
      definition_json = IO.read(path)
      definition_attr = JSON.parse definition_json, :symbolize_names => true
      definition = Definition.where(name: definition_attr[:name]).first_or_initialize(definition_attr)
      definition.update_attributes(definition_attr)
      puts "Saving #{path}"
      definition.save
    end
    #  assessment_path = File.expand_path('../../assessment.json', __FILE__)
    #definition = Definition.first
    #modified = check_if_inputs_modified(definition, assessment_path)
    #
    #if (modified)
    #  puts 'Definition modified, creating new...'
    #  stages = IO.read(assessment_path)
    #  parsed_stages = JSON.parse stages
    #
    #  name = 'Baseline Assessment'
    #  instructions = 'This test assesses your personality based on the Big 5 personality types. Please take a moment to take this test.'
    #  end_remarks = 'Congratulations. Please take a moment to register!'
    #
    #  if definition.nil?
    #    definition = Definition.create!(name: name,
    #                                stages: parsed_stages,
    #                                instructions: instructions,
    #                                end_remarks: end_remarks)
    #    # assessment = Assessment.create!(date_taken: "2012-12-23 18:05:01")
    #    # assessment.definition = definition
    #  else
    #    definition.stages = parsed_stages
    #    definition.name = name
    #    definition.instructions = instructions
    #    definition.end_remarks = end_remarks
    #    definition.save!
    #  end
    #end
  end
end