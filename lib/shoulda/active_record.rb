require 'shoulda'
require 'shoulda/active_record/helpers'
require 'shoulda/active_record/matchers'
require 'shoulda/active_record/assertions'
require 'shoulda/active_record/macros'

module Test # :nodoc: all
  module Unit
    class TestCase
      include ThoughtBot::Shoulda::ActiveRecord::Helpers
      include ThoughtBot::Shoulda::ActiveRecord::Matchers
      include ThoughtBot::Shoulda::ActiveRecord::Assertions
      extend ThoughtBot::Shoulda::ActiveRecord::Macros
    end
  end
end
