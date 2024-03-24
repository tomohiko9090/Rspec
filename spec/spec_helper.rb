require 'pry'
RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.color = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = false
  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end
