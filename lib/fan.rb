class Fan < ActiveRecord::Base
  belongs_to :fannable, :polymorphic => true
    
  #Models are liked by users 
  belongs_to :user
    
  #find methods to help find fannable elements
  def self.find_fannables_by_user(user)
    find(:all,
      :conditions => ["user_id = ?", user.id],
      :order => "created_at DESC"
    )
  end
  
  def self.find_fans_for_fannable(fannable_element, fannable_id)
    find(:all,
      :conditions => ["fannable_type = ? and fannable_id = ?", fannable_element, fannable_id],
      :order => "created_at DESC"
    )
  end

  # Helper class method to look up a fannable object
  def self.find_fannable(fannable_element, fannable_id)
    fannable_element.constantize.find(fannable_id)
  end
  
end