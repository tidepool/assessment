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

end
