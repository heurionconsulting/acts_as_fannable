# ActsAsFannable
module HeurionConsulting
  module Acts
    module Fannable 

      def self.included(base)
        base.extend ClassMethods  
      end

      module ClassMethods
        def acts_as_fannable
          has_many :fans, :as => :fannable, :dependent => :destroy, :order => 'created_at ASC'
          include HeurionConsulting::Acts::Fannable::InstanceMethods
          extend HeurionConsulting::Acts::Fannable::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods
        # Helper method to lookup for fans of a model
        def find_fans_for(obj)
          fanobject = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
         
          Fan.find(:all,
            :conditions => ["fannable_id = ? and fannable_type = ?", obj.id, fanobject],
            :order => "created_at DESC"
          )
        end
        
        def find_fannables_by_user(user) 
          fanobject = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
          
          Fan.find(:all,
            :conditions => ["user_id = ? and fannable_type = ?", user.id, fanobject],
            :order => "created_at DESC"
          )
        end
        
        
      end
      
      # This module contains instance methods
      module InstanceMethods
        # Helper method to sort fan by date
        def fans_by_recent
          Fan.find(:all,
            :conditions => ["fannable_id = ? and fannable_type = ?", id, self.type.name],
            :order => "created_at DESC"
          )
        end
        
        # Helper method that defaults the submitted time.
        def add_fan(fan)
          fans << fan
        end
        
        def is_fan?(user)
         fan = Fan.find(:all,
            :conditions => ["user_id = ? and fannable_type = ? and fannable_id = ?",user.id, self.type.name,self.id]
          )
          !(fan.nil?)
        end
        
      end
    end
  end
end
