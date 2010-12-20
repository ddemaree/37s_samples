module MMC::PartyBehaviors
  
  def self.included(base)
    base.class_eval do
      has_one :party, :as => :party
      after_save :update_party
      after_destroy :destroy_party
      
      # These associations date back to before Party was added to the project
      [:content_items, :events, :posts, :discussions, :attachments, :comments, :pages].each do |association_name|
        has_many association_name, :as => :owner
      end
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
  
  def to_s(variant=nil)
    name
  end
  
end