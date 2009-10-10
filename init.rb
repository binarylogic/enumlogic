require 'enumlogic'

ActiveRecord::Base.class_eval do
  include Enumlogic
end