require File.join(File.dirname(__FILE__), '..', 'test_helper')

class MultipleContextsTest < Test::Unit::TestCase
  include Shoulda::MultipleContexts

  class << self
    def should_match_regex string, *groups
      context "matching #{string.inspect}" do
	should("match") { assert_match @regex, string }

	unless groups.blank?
	  context "should capture groups #{groups.inspect}" do
	    evaluate { @captures = @regex.match(string).captures }
	    should("match expected group values") do
	      assert_equal groups, @captures
	    end
	  end
	end
      end
    end

    def should_not_match_regex string
      should "not match #{string.inspect}" do
	assert_no_match @regex, string
      end
    end
  end

  should "pass truthitest" do
    assert true
  end

  context "#with_contexts_method_regex" do
    evaluate { @regex = with_contexts_method_regex }
  end

  context "#method_missing_with_multiple_contexts" do
    setup do
      stubs(:conditional_contexts).with { |contexts, block| @conditional_contexts, @conditional_block = contexts, block }.returns :conditional_contexts
      @block = proc { }
    end
    evaluate { assert_equal :conditional_contexts, method_missing_with_multiple_contexts(@method_name, &@block) }

    context "for 'with_foo_or_bar'" do
      setup { @method_name = "with_foo_or_bar" }
      should "recognize the contexts" do
        assert_equal ["foo", "bar"], @conditional_contexts
      end

      should("forward the block") { assert_equal @block, @conditional_block }
    end
  end

  context "#conditional_contexts" do
    setup do
      @block = proc { }
    end
    evaluate { conditional_contexts @contexts, @block }

    context "with a single context" do
      setup do
        @contexts = [ "foo" ]
        stubs(:with_foo).with { |*args| @with_foo_args = args }.yields :with_foo
      end
      should "invoke 'with_foo'" do
        assert_equal [], @with_foo_args
      end
    end

    context "with two contexts" do
      setup do 
        @contexts = ['foo', 'bar_zeta']
        stubs(:with_foo).with { @with_foo_invoked = true }.yields :with_foo
        stubs(:with_bar_zeta).with { @with_bar_zeta_invoked = true }.yields :with_bar_zeta
      end
      should("invoke 'with_foo'") { assert @with_foo_invoked, 'with_foo should have been invoked' }
      should("invoke 'with_bar_zeta'") { assert @with_bar_zeta_invoked, 'with_bar_zeta should have been invoked' }
    end
  end

  context "#multiple_contexts_method_regex" do
    setup { @regex = multiple_contexts_method_regex }
    should_match_regex "with_foo_or_bar", 'foo_or_bar'
    should_not_match_regex "with_foo"
    should_match_regex "with_foo_or_bar_or_zeta", 'foo_or_bar_or_zeta'
  end

  module Macros
    def should_match_regex string, *groups
      context "matching #{string.inspect}" do
	should("match") { assert_match @regex, string }

	unless groups.blank?
	  context "should capture groups #{groups.inspect}" do
	    evaluate { @captures = @regex.match(string).captures }
	    should("match expected group values") do
	      assert_equal groups, @captures
	    end
	  end
	end
      end
    end

    def should_not_match_regex string
      should "not match #{string.inspect}" do
	assert_no_match @regex, string
      end
    end
  end
end
