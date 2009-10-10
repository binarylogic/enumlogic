$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'spec'
require 'spec/autorun'
require 'rubygems'
require 'active_record'
require "#{File.dirname(__FILE__)}/../init"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Base.configurations = true

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  create_table :computers do |t|
    t.string :kind
  end
end

Spec::Runner.configure do |config|
  config.before(:each) do
    class Computer < ActiveRecord::Base
    end
  end
  
  config.after(:each) do
    Object.send(:remove_const, :Computer)
  end
end
