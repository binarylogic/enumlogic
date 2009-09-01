require "activerecord"

module Enumlogic
  # enum_field encapsulates a validates_inclusion_of and automatically gives you a 
  # few more goodies automatically.
  # 
  #     class Computer < ActiveRecord:Base
  #       enum_field :status, ['on', 'off', 'standby', 'sleep', 'out of this world']
  # 
  #       # Optionally with a message to replace the default one
  #       # enum_field :status, ['on', 'off', 'standby', 'sleep'], :message => "incorrect status"
  # 
  #       #...
  #     end
  # 
  # This will give you a few things:
  # 
  # - add a validates_inclusion_of with a simple error message ("invalid #{field}") or your custom message
  # - define the following query methods, in the name of expressive code:
  #   - on?
  #   - off?
  #   - standby?
  #   - sleep?
  #   - out_of_this_world?
  # - define the STATUSES constant, which contains the acceptable values
  def enum(field, values, options = {})
    values_hash = if values.is_a?(Array)
      hash = {}
      values.each { |value| hash[value] = value }
      hash
    else
      values
    end
    
    values_array = values.is_a?(Hash) ? values.keys : values
    
    message = options[:message] || "#{field} is not included in the list"
    constant_name = options[:constant] || field.to_s.pluralize.upcase
    const_set constant_name, values_array unless const_defined?(constant_name)
    
    new_hash = {}
    values_hash.each { |key, text| new_hash[text] = key }
    (class << self; self; end).send(:define_method, "#{field}_options") { new_hash }
    
    define_method("#{field}_key") do
      send(field).to_s.gsub(/[-\s]/, '_').downcase.to_sym
    end
    
    define_method("#{field}_text") do
      values_hash.find { |key, text| key == send(field) }.last
    end
    
    values_array.each do |value|
      method_name = value.downcase.gsub(/[-\s]/, '_')
      method_name = "#{method_name}_#{field}" if options[:namespace]
      define_method("#{method_name}?") do
        self.send(field) == value
      end
    end

    validates_inclusion_of field, :in => values_array, :message => message
  end
end

ActiveRecord::Base.extend Enumlogic