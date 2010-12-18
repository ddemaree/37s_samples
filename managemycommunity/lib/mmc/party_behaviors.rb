module MMC::PartyBehaviors
  
  def self.included(base)
    base.class_eval do
      has_one :party, :as => :party
      after_save :update_party
      after_destroy :destroy_party
    end
  end
  
  def update_party
    party = (self.party || self.build_party)
    party.attributes = {
      :subtype   => self.class.to_s,
      :name      => self.to_s,
      :signature => self.to_s # What should go in the signature besides the name?
    }
    party.save
  end

  def destroy_party
    self.party.destroy
  end
  
end