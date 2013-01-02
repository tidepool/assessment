require 'json'
# require 'active_support/core_ext/string/inflections'

module JSONSerializer
  def to_hash
  	hash = {}
  	instance_variables.each do |var|
      	value = instance_variable_get var.to_sym
      	var_name = var[1..-1].camelize :lower
      	hash[var_name] = (value.respond_to? :to_hash) ? value.to_hash : value;
  	end
  	hash
	end

	def to_json(*arg)
  	to_hash.to_json *arg
	end

	def from_json(json)
		from_hash(JSON.load(json))
	end
	
	def from_hash(hash)
		hash.each do |key, value|
			instance_var_name = "@#{key.underscore}"
			if (value.class == Hash)
				begin
					obj = Object.const_get(key.capitalize).new
					obj.from_hash(value)
					instance_variable_set instance_var_name, obj
				rescue
					# if not found
					puts "NOT FOUND!!! #{key}"
					instance_variable_set instance_var_name, value
				end
			else
				instance_variable_set instance_var_name, value
			end
		end	
	end
end
