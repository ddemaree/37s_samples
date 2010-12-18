class Party < ActiveRecord::Base
  
  IndexedClasses = [User, Group]
  WordsToIgnore  = %w(and or not)
  SearchColumns  = %w(name signature subtype)
  
  named_scope :for_query, lambda { |query_string| {:conditions => Party.query_conditions(query_string), :order => "name ASC"} }
  
  belongs_to :party, :polymorphic => true
  validates_presence_of :name
  
  def self.query_conditions(query_string)
    clauses = []
    
    KeywordSearch.search(query_string) do |with|
      with.default_keyword :name
      
      with.keyword :name do |values|
        values.each do |word|
          next if WordsToIgnore.include?(word.downcase)
          quoted_word = connection.quote("%#{word}%")
          
          clauses << SearchColumns.inject([]) do |clause, column|
            clause << "(#{column} like #{quoted_word})"; clause
          end.join(" OR ")
        end
      end
    end
    
    clauses.map{|c| "(#{c})"}.join(' AND ')
  end
  
  def to_s
    self.name
  end
  
  def subject_label
    result_type.humanize
  end
  
  def subject_class
    subject_label.downcase.gsub(/[^a-z]/,"_")
  end
  
  def klass
    subject_label == "Weight" ? "Font::Weight" : subject_type
  end
  
  
end
