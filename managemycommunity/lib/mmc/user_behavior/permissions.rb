module MMC::UserBehavior::Permissions

  def self.included(base)
    base.class_eval do
      
      # Associations #
      belongs_to :group
      has_many :group_assignments, :order => "is_primary DESC, id ASC"
      has_many :microsite_assignments, :class_name => "GroupAssignment", :order => "is_primary DESC, id ASC"
      has_many :microsites, :through => :microsite_assignments
    
      # Scopes #
      named_scope :admins, :conditions => "is_admin = 1"
      named_scope :nonadmins, :conditions => "is_admin = 0 OR is_admin IS NULL"
    
    end
  end
  
  def is_board_member?
    self.group_assignments.collect { |ga| (ga.privilege >= 2 ? true : false)  }.include?(true)
  end

  def can_update_case?(case_file)
    return !!self.is_admin
  end
  
  def is_admin_for?(object)
    return !!self.is_admin
  end
  
  def update_group_assignment!
    logger.debug("Trying to set group to new microsite")
    self.group = self.microsite
    self.save!
  end
  
  def allowed?(user, requirement=0)
    return true if user.is_admin
    user == self
  end
  
  def privilege_for(user)
    return 3 if user.is_admin
    user == self ? 2 : 0
  end
  
  def self.writeable_by_options
    [["Just me", 2]]
  end
  
  def self.readable_by_options
    [["Anybody",0], ["Me and my neighbors only",1], ["Just me",2]]
  end
  
  def building
    return group unless group.nil?
    first_assign = microsite_assignments.first
    first_assign.microsite if first_assign
  end
  alias_method :microsite, :building
  
protected

  def add_to_initial_group
    if !self.initial_group.blank?
      group_class, group_id = self.initial_group.split(":")
      group = Group.find(group_id)
      
      group.user_assignments.create!({
        :user => self,
        :privilege => (self.initial_privilege || 1)
      })
      
      self.group = group
    end
  end
  
end