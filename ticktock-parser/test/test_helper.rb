require 'bundler'
Bundler.setup

require 'active_support'
require 'shoulda'

# Add lib directory to load path
$:<< File.expand_path("../../lib", __FILE__)