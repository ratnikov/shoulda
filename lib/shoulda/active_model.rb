require 'shoulda'
require 'shoulda/active_model/matchers'
require 'shoulda/active_model/assertions'
require 'shoulda/active_model/macros'

module Test # :nodoc: all
  module Unit
    class TestCase
      include Shoulda::ActiveModel::Matchers
      include Shoulda::ActiveModel::Assertions
      extend Shoulda::ActiveModel::Macros
    end
  end
end
