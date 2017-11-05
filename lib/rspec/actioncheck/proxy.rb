require 'rspec/actioncheck/helpers'

RSpec.configure do |config|
  config.include RSpec::ActionCheck::Helpers
  config.extend RSpec::ActionCheck::Helpers::ClassMethods
end
