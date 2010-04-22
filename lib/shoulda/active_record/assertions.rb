module Shoulda # :nodoc:
  module ActiveRecord # :nodoc:
    module Assertions
      # Asserts that the given object can be saved
      #
      #  assert_save User.new(params)
      def assert_save(obj)
        assert obj.save, "Errors: #{pretty_error_messages obj}"
        obj.reload
      end
    end
  end
end
