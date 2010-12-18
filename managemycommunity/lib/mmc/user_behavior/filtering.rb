module MMC::UserBehavior::Filtering
  
  def self.included(base)
    base.send(:extend, ClassMethods)
  end
  
  module ClassMethods
    def search(params={},options={})
      find(:all, options_for_search(params).merge(options))
    end

    def options_for_search(params={}, options={})
      params.stringify_keys!

      search_options = {
        :joins => "LEFT JOIN group_assignments ON group_assignments.user_id = users.id",
        :group => "users.id"
      }
      search_conditions = params.inject([]) do |coll, param|
        key, value = param

        unless value.blank?
          coll <<
            case key
              when 'name', 'email', 'query'
                search_conditions_for_string(key, value)
              when 'microsite'
                search_conditions_for_microsite(value)
              when 'board_member'
                "group_assignments.privilege = 2"
              when 'is_admin'
                "users.is_admin = 1"
            end
        end

        coll
      end

      search_conditions.reject! { |sc| (sc.nil? || sc.blank?) }
      return {} if search_conditions.blank?

      search_options.merge!({
        :conditions => search_conditions.collect { |c| "(#{c})" }.join(" AND ")
      })

      search_options
    end

    def search_conditions_for_microsite(value)
      value =
        case value
          when /,/ then value.split(/,/)
          when String then Array(value)
          when Array  then value
        end

      value.collect { |ms_id| "(group_assignments.group_id = '#{ms_id}')" }.join(" OR ")
    end

    def search_conditions_for_string(key, value)    
      if key == 'query'
        %w(login first_name last_name email co_first_name co_last_name).collect { |k| "users.#{k} LIKE '%#{value}%'" }.join(" OR ")
      else
        Array(value).collect { |v| "users.#{key} LIKE '%#{v}%'" }.join(" AND ")
      end
    end
  
  end

end