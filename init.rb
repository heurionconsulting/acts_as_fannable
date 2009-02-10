# Add any initiallizable activities
require 'acts_as_fannable'
ActiveRecord::Base.send(:include, HeurionConsulting::Acts::Fannable)
