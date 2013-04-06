require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rails'
  require 'factory_girl'
  require 'factory_girl_rails'

  Capybara.javascript_driver = :webkit

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random"
    config.include FactoryGirl::Syntax::Methods
    config.backtrace_clean_patterns = [ ]
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  ActiveSupport::Dependencies.clear
end

def raw_stypi_snapshot(num)
  if num
    File.read(Rails.root.join('spec', 'support', "stypi#{num}.json")) 
  else
    File.read(Rails.root.join('spec', 'support', "invalid_stypi_json.json")) 
  end
end


