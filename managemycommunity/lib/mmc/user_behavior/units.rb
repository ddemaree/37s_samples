module MMC::UserBehavior::Units
  
  def self.included(base)
    base.class_eval do
      has_many :user_residencies
      has_many :residencies, :through => :user_residencies do
        def current
          find(:first, :conditions => ["moved_in_on <= ? AND (moved_out_on IS NULL OR moved_out_on >= ?)", Time.now, Time.now], :order => "moved_in_on ASC")
        end
      end
    end
  end
  
  def unit
    residencies.current.unit unless residencies.current.nil?
  end
  
  def residency
    residencies.first
  end
  
end