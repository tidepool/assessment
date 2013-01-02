class Definition < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :stages, :instructions, :end_remarks

  def self.find_or_return_default(def_id)
  	if def_id
  		self.find(def_id)
  	else
  		self.first
  	end
  end
end
