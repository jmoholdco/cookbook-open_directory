require 'chefspec'
require 'chefspec/berkshelf'
require 'chef-vault/test_fixtures'

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!

  config.include ChefVault::TestFixtures.rspec_shared_context(true)

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  else
    config.default_formatter = 'progress'
  end

  config.order = :random
  Kernel.srand config.seed
end
