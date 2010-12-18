require 'digest/sha1'

class User < ActiveRecord::Base
  include MMC::ParentModel
  include MMC::PartyBehaviors
  
  include MMC::UserBehavior::Filtering
  include MMC::UserBehavior::Permissions
  include MMC::UserBehavior::Units
  
  acts_as_paranoid  
  
  # Virtual attribute for the unencrypted password
  attr_accessor :legacy, :initial_group, :initial_privilege, :password
  
  attr_accessor_with_default :skip_email_validation_right_now, false
  alias_attribute :title, :name

  validates_presence_of     :first_name, :last_name
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 6..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  
  validates_presence_of   :login
  validates_length_of     :login, :within => 3..20
  validates_uniqueness_of :login, :case_sensitive => false
  
  validates_presence_of   :email, :unless => :skip_email_validation_right_now
  #validates_uniqueness_of :email, :case_sensitive => false, :unless => :skip_email_validation_right_now
  validates_length_of     :email, :within => 3..100, :unless => :skip_email_validation_right_now

  validates_uniqueness_of :email, :case_sensitive => false, :if => :can_validate_password?
  
  before_validation :populate_clear_password
  after_create :deliver_welcome_message
  after_create :add_to_initial_group
  before_save :encrypt_password
  
  has_one :profile, :class_name => "UserProfile"
  has_many :photos, :as => :item
  has_many :notes, :as => :item
  has_many :case_searches, :class_name => "Cases::Search"
  has_many :activity_logs, :order => 'created_at DESC'
  has_many :friendships, :dependent => :destroy
  has_many :friends, :through => :friendships
  has_many :reverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id", :dependent => :destroy
  has_many :reverse_friends, :through => :reverse_friendships, :source => :user
  has_many :vendors
  has_many :settings  
  has_one :avatar, :as => :subject  
  
  named_scope :with_keywords, lambda { |k| {:conditions => User.conditions_for_keyword(k) }  }
  
  def self.find_by_login(login_or_id)
    self.first(:conditions => {:login => login_or_id}) ||
    self.find_by_id(login_or_id)
  end
  
  def self.find_by_login!(login_or_id)
    self.find_by_login(login_or_id) or raise(RecordNotFound, "Could not find User with login or id #{login_or_id}")
  end
  
  def self.conditions_for_keyword(query)
    if query.to_s.blank?
      nil
    else
      params =
        %w(first_name last_name email).inject({}) do |coll, key|
          coll["#{key}_keywords"] = query; coll
        end
      
      params.merge!({:any => true, :group => {:microsite_title_keywords => query, :microsite_shortname => query, :any => true}})
      logger.info(params.inspect)
      params
    end
  end
  
  
  def concerning_key
    "P#{self.id}"
  end
  
  def to_param
    if login.blank?
      "#{id}-NOLOGIN"
    elsif login =~ /[^a-zA-Z0-9\-_]/
      "#{id}-#{login.gsub(/[^a-zA-Z0-9\-_]/,"_")}"
    else
      login
    end
  end
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    with_scope(:find => {:conditions => {:is_disabled => false}}) do
      u = (login.blank? || password.blank?) ? nil : find_by_login(login) # need to get the salt
    
      if (u && u.authenticated?(password))
        [u, nil]
      elsif u
        [nil, "The password you entered did not match our records"]
      elsif login.blank?
        [nil, "You must enter a username to log in"]
      elsif password.blank?
        [nil, "You must enter your password to log in"]
      else
        [nil, "The username you entered was not found"]
      end
    end
  end
  
  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    (crypted_password == encrypt(password)) || (old_password_hash == Digest::MD5.hexdigest(password))
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  def name
    if first_name.blank? && last_name.blank? && login.blank?
      "Name Unknown"
    elsif first_name.blank? && last_name.blank?
      login
    elsif first_name.blank? or last_name.blank?
      first_name || last_name
    else
      "#{first_name} #{last_name}"
    end
  end
  
  def to_s(variant=nil)
    name
  end
  
  def loggable?
    no_log_fields = %w(created_on updated_on deleted_at remember_token_expires_at remember_token imported_at batch_import)
    clean_changed = changed.reject { |ch| no_log_fields.include?(ch) }    
    !clean_changed.empty?
  end
  
  def avatar_data=(data)
    @avatar_data = self.build_avatar(:uploaded_data => data) if data.respond_to?(:original_filename)
  end
  
  def scope
    Array(self) + self.microsites
  end
  
  def cases_scope
    returning([]) do |scope_set|
      scope_set << self
      scope_set << self.unit if self.unit
      
      self.microsite_assignments.each do |assign|
        scope_set << assign.microsite if assign.privilege == 2
      end
      
    end
  end
  
  def cases_in_scope
    @cases_in_scope ||=
      if self.is_admin
        Cases::File.find_filtered(:all, :owner => self.id, :state => "new_and_opened", :limit => 15, :order => "last_update DESC")
      else
        Cases::File.find_filtered(:all, :scope => self.cases_scope, :state => "new_and_opened", :limit => 15, :order => "last_update DESC")
      end
  end
  
  def is_admin?
    !!is_admin
  end
  
  def owner
    self
  end
  alias_method :owner_without_fallback, :owner
  
  def editable_by(user)
    user == self
  end
  
  def reset_password!(deliver_email=true)
    new_password = Practical::PasswordGenerator.humane
    self.password = new_password
    self.password_confirmation = new_password
    
    if self.save
      Notifier.deliver_new_password(self, new_password) if deliver_email
      return new_password
    else
      return false
    end
  end
  
  def deliver_welcome_message
    Notifier.deliver_welcome_message(self, password)
  end
  
  def clear_pw_is_valid?
    return false if self.clear_password.blank?
    return !!self.authenticated?(self.clear_password)
  end
  
  def clear_or_new_password
    clear_pw_is_valid? ? clear_password : reset_password!(false)
  end
  
  # Pattern for grabbing info from associated objects with graceful
  # failure without having to gunk up my pretty, pretty templates
  def fetch(message,response=nil)
    self.instance_eval(message) rescue response
  end

protected

  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end
  
  def password_required?
    return false if (!new_record? && !clear_password.blank?)
    
    crypted_password.blank? || !password.blank?
  end
  
  def can_validate_password?
    password_required?
  end
  
  def legacy_password_only?
    crypted_password.blank? || !old_password_hash.blank?
  end
  
  def populate_clear_password
    if !self.password.blank?
      self.clear_password = self.password
    end
  end
    
end
