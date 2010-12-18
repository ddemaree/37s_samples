class Group < ActiveRecord::Base
  include MMC::ParentModel
  include MMC::PartyBehaviors
  
  class_inheritable_accessor :default_description
  alias_attribute :group_type, :type
  
  validates_presence_of :microsite_title, :microsite_shortname
  validates_uniqueness_of :microsite_shortname
  validates_length_of :microsite_shortname, :in => (3..10)
  
  has_many :user_assignments, :class_name => "GroupAssignment", :dependent => :destroy
  has_many :users, :through => :user_assignments
  
  has_many :board_member_assignments, :class_name => "GroupAssignment", :conditions => "privilege = 2"
  has_many :board_members, :through => :board_member_assignments, :source => :user
  
  has_many :board_memberships, :dependent => :destroy
  
  has_many :vendor_relationships, :dependent => :destroy
  has_many :vendors, :through => :vendor_relationships
  
  has_many :events, :as => :item
  has_one :avatar, :as => :subject, :dependent => :destroy
  
  has_many :units, :foreign_key => :building_id, :dependent => :destroy
  has_many :building_assets, :foreign_key => :building_id, :dependent => :destroy
  has_many :reservations, :through => :building_assets, :dependent => :destroy
  
  has_many :board_meetings, :as => :owner, :class_name => "Event", :conditions => "board_meeting = 1" do
    def find_or_initialize_all_by_year(year=Time.now.year)
      year = year.to_i
      extant_meetings = find_all_by_board_meeting_year(year,  :order => "board_meeting_quarter ASC").group_by(&:board_meeting_quarter).sort
      logger.info("Extant meetings for #{proxy_owner}: #{extant_meetings.inspect}")

      %w(Annual Q1 Q2 Q3 Q4).inject({}) do |group, quarter|
        extant_meeting = extant_meetings[quarter].first if extant_meetings[quarter]
        
        group[quarter] = extant_meeting || self.build({
          :board_meeting_year => year,
          :board_meeting_quarter => quarter,
          :title => "#{quarter} Board Meeting",
          :start_date => BoardMeeting.first_business_day_of_quarter(year,quarter),
          :owner => proxy_owner,
          :item => proxy_owner,
          :board_meeting => true
        })
        group
      end
    end
  end
  
  has_many :photos, :as => :item do
    def featured
      find(:all, :conditions => "board_meeting = 1", :limit => 5, :order => "created_at DESC")
    end
  end
  
  has_many :notes, :as => :item
  
  def self.options_for_admin_select
    [["--- All Communities ---",""]] + Group.options_for_select(:value => :owner_string, :find => {:order => "microsite_title ASC"})
  end

  alias_attribute :name, :microsite_title
  alias_attribute :title, :microsite_title
  
  def concerning_key
    "M#{self.id}"
  end
  
  def to_param
    microsite_shortname
  end
  
  def to_s(variant=nil)
    case variant
      when :short then short_name
      when :slug  then microsite_shortname
      else microsite_title
    end
  end
  
  def editable_by(user)
    user.is_admin || self.users.find_by_id(user.id)
  end
  
  def allowed?(user, requirement=0)
    return false if user.nil? or user == :false
    return true if user.is_admin
    
    !!(privilege_for(user) >= requirement)
  end
  
  def is_group?
    true
  end
  
  def privilege_for(user)
    return 3 if user.is_admin
    
    uma = user_assignments.find_by_user_id(user)
    !uma.nil? ? uma.privilege : 0
  end
  
  def self.writeable_by_options
    [["All unit owners and admins",1], ["Board members and admins",2], ["Admins only",3]]
  end
  
  def self.readable_by_options
    [["Anybody",0], ["Unit owners only",1], ["Board members and admins only",2]]
  end
  
  def avatar_data=(data)
    @avatar_data = self.build_avatar(:uploaded_data => data) if data.respond_to?(:original_filename)
  end
  
  def owner
    self
  end
  alias_method :owner_without_fallback, :owner
  
end