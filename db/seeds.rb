# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
require 'csv'

# Load the default stages JSON file
stages = IO.read(File.expand_path('../assessment.json', __FILE__))
parsed_stages = JSON.parse stages 

name = "Baseline Assessment"
instructions = "This test assesses your personality based on the Big 5 personality types. Please take a moment to take this test."
end_remarks = "Congratulations. Please take a moment to register!"

definition = Definition.first 
if definition.nil?
	definition = Definition.create!(name: name, 
															stages: parsed_stages,
															instructions: instructions,
															end_remarks: end_remarks)
	assessment = Assessment.create!(date_taken: "2012-12-23 18:05:01", score: "maverick")
	assessment.definition = definition
else
	definition.stages = parsed_stages
	definition.name = name
	definition.instructions = instructions
	definition.end_remarks = end_remarks
	definition.save!
end

image = Image.first
updated_at = image.updated_at if !image.nil?
image_elements_path = File.expand_path('../image_elements.csv', __FILE__)
image_coding_path = File.expand_path('../image_codings.csv', __FILE__)


elements_modified_time = File.mtime(image_elements_path)
coding_modified_time = File.mtime(image_coding_path)
changed = false
if updated_at && (updated_at < elements_modified_time or updated_at < coding_modified_time)
	changed = true
end

if image.nil? or changed
	image_elements = []
	CSV.foreach(image_elements_path) do |row|
		image_elements = row
	end 
	CSV.foreach(image_coding_path) do |row|
		element_values = row
		image_name = ""
		element_value_string = ""
		primary_color = ""
		count = 0
		element_values.each do |value|
			image_name = value if count == 0 
			element_value_string += "#{image_elements[count - 1]}," if value == "1"			
			primary_color = value if image_elements[count - 1] == "cf:primary_color"
			count += 1
		end
		image = Image.where(name: image_name).first_or_initialize({
				elements: element_value_string,
				primary_color: primary_color
			})
		if !image.nil?
			image.elements = element_value_string.chomp(',')
			image.primary_color = primary_color
			puts "Image created - #{image.name}, #{image.elements}, Color:#{image.primary_color}"
			image.save
		end
	end
end