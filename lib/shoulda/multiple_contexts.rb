module Shoulda
  module MultipleContexts
    # == Multiple Contexts Support
    #
    # This module allows specifying a block of shoulda statements to be executed within multiple contexts.
    # The rationale of the approach is to allow validation of identical behavior within different contexts.
    #
    # === Example:
    #
    #  class FooTest
    #    class << self
    #      def with_string &block
    #        context "with foo" do
    #        setup { @foo = :foo }
    #        instance_exec &block
    #      end
    #  
    #      def with_symbol &block
    #        context "with foo" do
    #        setup { @foo = "bar" }
    #        instance_exec &block
    #      end
    #    end
    #
    #    with_string_or_symbol do
    #      context "#to_my_string"
    #        evaluate { @to_my_string = @foo.to_my_string }
    #        should("be same as #to_s) { assert_equal @foo.to_s, @to_my_string }
    #      end
    #    end
    #  end
    #
    # ...will produce following tests:
    # * <tt>"test: with string #to_my_string should be same as #to_s. "</tt>
    # * <tt>"test: with symbol #to_my_string should be same as #to_s. "</tt>
    #
    # === NOTE
    # 
    # Current implementation relies on following convention of custom context naming:
    # * name of the method has to start with <tt>with_</tt> .
    # * name should not contain <tt>_or_</tt>.
    #
    # When defining custom context, you need to make sure to invoke <tt>instance_exec &block</tt> to invoke the
    # customization block within the newly defined context.

    def self.included base
      base.class_eval do
	alias method_missing_without_multiple_contexts method_missing
	alias method_missing method_missing_with_multiple_contexts
      end
    end

    def conditional_contexts context_names, block
      context_names.each do |context_name|
	send "with_#{context_name}", &block
      end
    end

    def method_missing_with_multiple_contexts method, *args, &block
      if method.to_s =~ multiple_contexts_method_regex
	raise "Block missing" if block.blank?
	context_names = $1.split(/_or_/)
	conditional_contexts context_names, block
      else
	method_missing_without_multiple_contexts method, *args, &block
      end
    end

    private

    def multiple_contexts_method_regex
      context_mask = '[a-zA-Z]\w*'
      /^with_(#{context_mask}(?:_or_#{context_mask})+)$/
    end
  end
end
