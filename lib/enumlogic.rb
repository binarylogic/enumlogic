require "active_record"

# See the enum class level method for more info.
module Enumlogic
  # Allows you to easily specify enumerations for your models. Specify enumerations like:
  #
  #   class Computer < ActiveRecord::Base
  #     enum :kind, ["apple", "dell", "hp"]
  #     enum :kind, {"apple" => "Apple", "dell" => "Dell", "hp" => "HP"}
  #   end
  #
  # You can now do the following:
  #
  #   Computer::KINDS # passes back the defined enum keys as array
  #   Computer.kind_options # gives you a friendly hash that you can easily pass into the select helper for forms
  #   Computer.new(:kind => "unknown").valid? # false, automatically validates inclusion of the enum field
  #   
  #   c = Computer.new(:kind => "apple")
  #   c.apple? # true
  #   c.kind_key # :apple
  #   c.kind_text # "apple" or "Apple" if you gave a hash with a user friendly text value
  #   c.enum?(:kind) # true
  def enum(field, values, options = {})
    values_hash = if values.is_a?(Array)
      hash = {}
      values.each { |value| hash[value] = value }
      hash
    else
      values
    end
    
    values_array = values.is_a?(Hash) ? values.keys : values
    
    constant_name = options[:constant] || field.to_s.pluralize.upcase
    const_set constant_name, values_array unless const_defined?(constant_name)
    
    new_hash = {}
    values_hash.each { |key, text| new_hash[text] = key }
    (class << self; self; end).send(:define_method, "#{field}_options") { new_hash }
    
    define_method("#{field}_key") do
      value = send(field)
      return nil if value.nil?
      value.to_s.gsub(/[-\s]/, '_').downcase.to_sym
    end
    
    define_method("#{field}_text") do
      value = send(field)
      return nil if value.nil?
      values_hash[value]
    end
    
    values_array.each do |value|
      method_name = value.downcase.gsub(/[-\s]/, '_')
      method_name = "#{method_name}_#{field}" if options[:namespace]
      define_method("#{method_name}?") do
        self.send(field) == value
      end
    end

    validates_inclusion_of field, :in => values_array, :message => options[:message], :allow_nil => options[:allow_nil], :if => options[:if]
  end

  def enum?(name)
    method_defined?("#{name}_key")
  end
end