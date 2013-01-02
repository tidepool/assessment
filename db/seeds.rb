# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

# Load the default stages JSON file
stages = IO.read(File.expand_path('../assessment.json', __FILE__))
name = "Baseline Assessment"
instructions = "This test assesses your personality based on the Big 5 personality types. Please take a moment to take this test."
end_remarks = "Congratulations. Please take a moment to register!"

definition = Definition.first 
if definition.nil? 
	definition = Definition.create!(name: name, 
															stages: stages,
															instructions: instructions,
															end_remarks: end_remarks)
	assessment = Assessment.create!(date_taken: "2012-12-23 18:05:01", score: "maverick")
	assessment.definition = definition
else
	definition.stages = stages
	definition.name = name
	definition.instructions = instructions
	definition.end_remarks = end_remarks
	definition.save!
end