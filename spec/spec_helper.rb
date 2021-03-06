require 'sinatra'
require 'pg'
require 'rack'
require 'rack/test'
require 'rake'
require 'sidekiq/testing'
require './lib/db_manager'
require './lib/clinical_exams'
require './server'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  Sidekiq::Worker.clear_all
  Sidekiq::Testing.inline!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:suite) do
    Rake.load_rakefile './Rakefile'
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
