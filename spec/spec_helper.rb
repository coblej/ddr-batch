ENV['RAILS_ENV'] ||= "test"

require "coveralls"
Coveralls.wear!("rails")

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require "ddr-models"
require "rails"
require "rspec/rails"
require "rspec/matchers"
require "equivalent-xml/rspec_matchers"
require "factory_girl_rails"
require "database_cleaner"
require "tempfile"

Dir[File.join(File.dirname(__FILE__), "support", "*.rb")].each { |f| require f }

DatabaseCleaner.strategy = :truncation

require "ddr-antivirus"
Ddr::Antivirus.configure do |config|
  config.scanner_adapter = :null
  require "logger"
  config.logger = Logger.new(File::NULL)
end

RSpec.configure do |config|

  config.include ActionDispatch::TestProcess
  config.fixture_path = File.join(Ddr::Batch::Engine.root, "spec", "fixtures")
  config.use_transactional_fixtures = true  

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    # be_bigger_than(2).and_smaller_than(4).description
    #   # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #   # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Limits the available syntax to the non-monkey patched syntax that is recommended.
  # For more details, see:
  #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
  #   - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://myronmars.to/n/dev-blog/2014/05/notable-changes-in-rspec-3#new__config_option_to_disable_rspeccore_monkey_patching
  config.disable_monkey_patching!

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = false

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  # config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  # Devise helpers
  config.include Devise::TestHelpers, type: :controller

  # Warden helpers
  config.include Warden::Test::Helpers, type: :feature
  Warden.test_mode!

  config.before(:suite) do
    DatabaseCleaner.clean
    ActiveFedora::Base.destroy_all
    FileUtils.copy(File.join(Ddr::Batch::Engine.root.to_s, 'config', 'folder_ingest.yml.sample'),
                    File.join(Ddr::Batch::Engine.root.to_s, 'spec', 'dummy', 'config', 'folder_ingest.yml'))
  end

  config.after(:each) do
    ActiveFedora::Base.destroy_all
    FileUtils.rm_rf('spec/dummy/public/system')
  end

  config.after(:each, type: :feature) { Warden.test_reset! }

  config.after(:suite) do
    File.delete(File.join(Ddr::Batch::Engine.root.to_s, 'spec', 'dummy', 'config', 'folder_ingest.yml')) if
      File.exists?(File.join(Ddr::Batch::Engine.root.to_s, 'spec', 'dummy', 'config', 'folder_ingest.yml'))
    end

end
