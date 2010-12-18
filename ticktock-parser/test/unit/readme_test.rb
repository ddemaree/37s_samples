require 'test_helper'
require 'event/message_parser'

class Event::MessageParserTest < Test::Unit::TestCase
  
  context "date examples" do
    should "parse dates in MM/DD/YYYY format" do
      message_body = "03/09/2009 Cleaned the gutters"
      parsed_params = Event::MessageParser.parse(:body => message_body)
      assert_not_nil parsed_params[:date]
      assert_equal   parsed_params[:date], "2009-03-09".to_date
    end
    
    should "parse dates in YYYY-MM-DD format" do
      message_body = "2009-04-15 Cleaned the gutters again"
      parsed_params = Event::MessageParser.parse(:body => message_body)
      assert_not_nil parsed_params[:date]
      assert_equal   parsed_params[:date], "2009-04-15".to_date
    end
  end
  
  context "duration examples" do
    should "parse durations in HH:MM format" do
      message_body = "0:45 Cardio workout"
      parsed_params = Event::MessageParser.parse(:body => message_body)
      assert_not_nil parsed_params[:duration]
      assert_equal   parsed_params[:duration], 45.minutes
    end
    
    should "parse durations in HH:MM:SS format" do
      expected_time = 8.hours + 23.minutes + 42
      
      message_body = "8:23:42 Watched Lost marathon"
      parsed_params = Event::MessageParser.parse(:body => message_body)
      assert_not_nil parsed_params[:duration]
      assert_equal   parsed_params[:duration], expected_time
    end
    
    should "parse durations in shorthand format" do
      message_body = "1h 14m Replenished bodily fluids"
      parsed_params = Event::MessageParser.parse(:body => message_body)
      assert_not_nil parsed_params[:duration]
      assert_equal   parsed_params[:duration], (1.hour + 14.minutes)
    end
  end
  
  context "subject examples" do
    should "parse subjects in @name format" do
      message_body = "@yoga Finally got into full wheel pose! #mybackhurts"
      parsed_params = Event::MessageParser.parse(:body => message_body)
      
      assert_not_nil parsed_params[:subject]
      assert_equal   "yoga", parsed_params[:subject]
    end
  end
  
  context "tag examples" do
    should "parse single word tags in #hashtag format" do
      message_body = "Brunch with #Lauren"
      parsed_params = Event::MessageParser.parse(:body => message_body)
      
      assert       parsed_params[:tags].is_a?(Array)
      assert       parsed_params[:tags].any?
      assert_equal ["Lauren"], parsed_params[:tags]
    end
    
    should "preserve tags in the original message source" do
      message_body = "12/3/2010 Brunch with #Lauren and #Tim"
      parsed_params = Event::MessageParser.parse(:body => message_body)
      
      assert       parsed_params[:tags].any?
      assert_equal ["Lauren", "Tim"], parsed_params[:tags]
      
      # Date is stripped out, but tags remain in place
      assert_equal "2010-12-03".to_date, parsed_params[:date]
      assert_equal "Brunch with #Lauren and #Tim", parsed_params[:body]
    end
  end
  
end