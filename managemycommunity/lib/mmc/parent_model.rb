module MMC::ParentModel
  
  def self.included(base)
    base.class_eval do
      [:content_items, :events, :posts, :discussions, :attachments, :comments, :pages].each do |association_name|
        has_many association_name, :as => :owner
      end
    end
  end
  
  def is_group?
    false
  end
  
  def to_s(variant=nil)
    name
  end
  
end