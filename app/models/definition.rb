Dir[File.expand_path('../generators/*.rb', __FILE__)].each {|file| require file }

class Definition < ActiveRecord::Base
  serialize :stages, JSON
  attr_accessible :name, :stages, :instructions, :end_remarks

  def self.find_or_return_default(def_id)
  	if def_id
  		self.find(def_id)
  	else
      self.first
  	end
  end

  def stages_from_stage_definition
    result = []
    self.stages.each do |stage|
      module_name = stage["view_name"]
      klass_name = "#{module_name.camelize}Generator"
      generator = klass_name.constantize.new(stage)
      result << generator.generate
    end  
    result
  end
end
