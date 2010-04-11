require 'shoulda/active_model/matchers'
require 'shoulda/active_record/matchers'
require 'shoulda/action_controller/matchers'
require 'active_support/test_case'

# :enddoc:
module ActiveSupport
  class TestCase
    include Shoulda::ActiveModel::Matchers
    include Shoulda::ActiveRecord::Matchers
    include Shoulda::ActionController::Matchers
  end
end
