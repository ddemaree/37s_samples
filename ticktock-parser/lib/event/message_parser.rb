require 'ticktock/parser'

class Event
  class MessageParser
    TimeRegex = /((?:\d+:\d+(?:\:\d+)?)|(?:\d+.\d+(?:h|hr|hour)))/

    # Parses message string into params
    def self.parse(params={})
      if params.is_a?(String)
        params = {:body => params}
      end

      # Save source
      params[:source] = params[:body]

      # Run body through the Ragel parser
      parser_results = Ticktock::Parser._parse(params[:body])

      # Do some very minor normalization
  		parser_results["date"] = nil if parser_results["date"] == {}

  		# Combine provided params with the parsed results
  		parsed_params = parser_results
      parsed_params[:source] = params[:body]

      parsed_params.symbolize_keys!
      parsed_params.reverse_merge!({
        :tags   => Array(parsed_params[:tags]),
        :action => 'create'
      })

      HashWithIndifferentAccess.new(parsed_params)
    end
    
    # Parses message string into params using regexes and liberal use of the sub! and scan methods. Deprecated in favor of the Ragel-based parser used in MessageParser.parse above.
    #   @param [Hash] params A hash of message parameters. The :body key is parsed and used to set or override values on this hash.
    #   @return [Hash] The result of parsing params[:body].
    def self.legacy_parse(params={})
      params.reverse_merge!({
        :body => "",
        :tags => Array(params[:tags]),
        :user_name => nil,
        :date => nil,
        :action => 'create'
      })
    
      returning(params) do |output|
        output[:source] = params[:body]
      
        return params if params[:body].nil?
      
        params[:body].sub!(/^(\w+)\b/) do |match|
          case match
            when 'start', 'stop', 'pause'
              params[:action] = $1
              ""
            else
              match
          end
        end
      
        # Unquoted tags without white space
        params[:body].scan(/\#(?:(\w+))\s*/) do |match|
          output[:tags] << $1; ""
        end

        # Quoted tags, which can contain spaces
        params[:body].scan(/\#(?:\"(.*?)\"\s*)/) do |match|
          output[:tags] << $1; ""
        end
      
        # Trackables denoted with brackets
        params[:body].sub!(/^(?:\[(.*?)\]\s*)/) do |match|
          output[:subject] = $1; ""
        end
      
        # Trackables denotes with Twitter-like @name syntax
        params[:body].gsub!(/(?:@([a-zA-Z0-9_]+))\s*/) do |match|
          output[:subject] = $1; ""
        end
      
        # Duration
        params[:body].sub!(TimeRegex) do |match|
          output[:duration] = Event::TimeParser.from_string($1); ""
        end
      
        # Date in MM/DD/YYYY
        params[:body].gsub!(/(?:^|\W)(\d{1,2})(?:\/|-)(\d{1,2})(?:\/|-)(\d{2,4})/) do |match|
          output[:date] = "#{$3}-#{$1.rjust(2,"0")}-#{$2.rjust(2,"0")}".to_date
          ""
        end
      
        # # Date using machine-readable format
        # params[:body].sub!(/\b(?:d|date)\:(?:([\d-]+)\s*)/) do |match|
        #   output[:date] = $1.to_date; ""
        # end
        # 
        # # Date using natural language
        # params[:body].sub!(/\b(?:d|date)\:(?:\"(.*?)\"\s*)/) do |match|
        #   output[:date] = Chronic.parse($1).to_date; ""
        # end

        params[:body].strip!
      end
    end
  
  end
end