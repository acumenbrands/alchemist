# Set gem root directory
ROOT = File.expand_path(File.join('..', '..'), __FILE__)
puts ROOT

# Require spec support files
Dir[File.join(ROOT, 'spec', 'support', '**', '*.rb')].each { |f| require f }

# Set load path for the gem itself
$LOAD_PATH.unshift(File.expand_path(ROOT))

require 'alchemist'
require 'pry'

# Require example content for integration tests
Dir[File.join(ROOT, 'example_content', 'classes', '*.rb')].each { |f| require f }
Dir[File.join(ROOT, 'example_content', 'recipes', '*.rb')].each { |f| require f }

RSpec.configure do |config|
    config.mock_with :rspec
end
