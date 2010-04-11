module Shoulda # :nodoc:
  module ActiveModel # :nodoc:
    # = Macro test helpers for your active model models
    #
    # These helpers will test most of the validations and associations for your ActiveModel models.
    #
    #   class UserTest < Test::Unit::TestCase
    #     should_validate_presence_of :name, :phone_number
    #     should_not_allow_values_for :phone_number, "abcd", "1234"
    #     should_allow_values_for :phone_number, "(123) 456-7890"
    #   end
    #
    # For all of these helpers, the last parameter may be a hash of options.
    #
    module Macros
      include Matchers

      # Ensures that the model cannot be saved if one of the attributes listed is not present.
      #
      # Options:
      # * <tt>:message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
      #   Regexp or string.  Default = <tt>I18n.translate('activemodel.errors.messages.blank')</tt>
      #
      # Example:
      #   should_validate_presence_of :name, :phone_number
      #
      def should_validate_presence_of(*attributes)
        message = get_options!(attributes, :message)

        attributes.each do |attribute|
          matcher = validate_presence_of(attribute).with_message(message)
          should matcher.description do
            assert_accepts(matcher, subject)
          end
        end
      end
      
      # Ensures that the model cannot be saved if one of the attributes listed is not unique.
      # Requires an existing model
      #
      # Options:

      # * <tt>:message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
      #   Regexp or string.  Default = <tt>I18n.translate('activemodel.errors.messages.taken')</tt>
      # * <tt>:scoped_to</tt> - field(s) to scope the uniqueness to.
      # * <tt>:case_sensitive</tt> - whether or not uniqueness is defined by an
      #   exact match. Ignored by non-text attributes. Default = <tt>true</tt>
      #
      # Examples:
      #   should_validate_uniqueness_of :keyword, :username
      #   should_validate_uniqueness_of :name, :message => "O NOES! SOMEONE STOELED YER NAME!"
      #   should_validate_uniqueness_of :email, :scoped_to => :name
      #   should_validate_uniqueness_of :address, :scoped_to => [:first_name, :last_name]
      #   should_validate_uniqueness_of :email, :case_sensitive => false
      #
      def should_validate_uniqueness_of(*attributes)
        message, scope, case_sensitive = get_options!(attributes, :message, :scoped_to, :case_sensitive)
        scope = [*scope].compact
        case_sensitive = true if case_sensitive.nil?

        attributes.each do |attribute|
          matcher = validate_uniqueness_of(attribute).
            with_message(message).scoped_to(scope)
          matcher = matcher.case_insensitive unless case_sensitive
          should matcher.description do
            assert_accepts(matcher, subject)
          end
        end
      end

      # Ensures that the attribute cannot be set to the given values
      #
      # Options:
      # * <tt>:message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
      #   Regexp or string. If omitted, the test will pass if there is ANY error in
      #   <tt>errors.on(:attribute)</tt>.
      #
      # Example:
      #   should_not_allow_values_for :isbn, "bad 1", "bad 2"
      #
      def should_not_allow_values_for(attribute, *bad_values)
        message = get_options!(bad_values, :message)
        bad_values.each do |value|
          matcher = allow_value(value).for(attribute).with_message(message)
          should "not #{matcher.description}" do
            assert_rejects matcher, subject
          end
        end
      end

      # Ensures that the attribute can be set to the given values.
      #
      # Example:
      #   should_allow_values_for :isbn, "isbn 1 2345 6789 0", "ISBN 1-2345-6789-0"
      #
      def should_allow_values_for(attribute, *good_values)
        get_options!(good_values)
        good_values.each do |value|
          matcher = allow_value(value).for(attribute)
          should matcher.description do
            assert_accepts matcher, subject
          end
        end
      end

      # Ensures that the length of the attribute is in the given range
      #
      # Options:
      # * <tt>:short_message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
      #   Regexp or string.  Default = <tt>I18n.translate('activemodel.errors.messages.too_short') % range.first</tt>
      # * <tt>:long_message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
      #   Regexp or string.  Default = <tt>I18n.translate('activemodel.errors.messages.too_long') % range.last</tt>
      #
      # Example:
      #   should_ensure_length_in_range :password, (6..20)
      #
      def should_ensure_length_in_range(attribute, range, opts = {})
        short_message, long_message = get_options!([opts], 
                                                   :short_message,
                                                   :long_message)
        matcher = ensure_length_of(attribute).
          is_at_least(range.first).
          with_short_message(short_message).
          is_at_most(range.last).
          with_long_message(long_message)

        should matcher.description do
          assert_accepts matcher, subject
        end
      end

      # Ensures that the length of the attribute is at least a certain length
      #
      # Options:
      # * <tt>:short_message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
      #   Regexp or string.  Default = <tt>I18n.translate('activemodel.errors.messages.too_short') % min_length</tt>
      #
      # Example:
      #   should_ensure_length_at_least :name, 3
      #
      def should_ensure_length_at_least(attribute, min_length, opts = {})
        short_message = get_options!([opts], :short_message)

        matcher = ensure_length_of(attribute).
          is_at_least(min_length).
          with_short_message(short_message)

        should matcher.description do
          assert_accepts matcher, subject
        end
      end

      # Ensures that the length of the attribute is exactly a certain length
      #
      # Options:
      # * <tt>:message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
      #   Regexp or string.  Default = <tt>I18n.translate('activemodel.errors.messages.wrong_length') % length</tt>
      #
      # Example:
      #   should_ensure_length_is :ssn, 9
      #
      def should_ensure_length_is(attribute, length, opts = {})
        message = get_options!([opts], :message)
        matcher = ensure_length_of(attribute).
          is_equal_to(length).
          with_message(message)

        should matcher.description do
          assert_accepts matcher, subject
        end
      end

      # Ensure that the attribute is in the range specified
      #
      # Options:
      # * <tt>:low_message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
      #   Regexp or string.  Default = <tt>I18n.translate('activemodel.errors.messages.inclusion')</tt>
      # * <tt>:high_message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
      #   Regexp or string.  Default = <tt>I18n.translate('activemodel.errors.messages.inclusion')</tt>
      #
      # Example:
      #   should_ensure_value_in_range :age, (0..100)
      #
      def should_ensure_value_in_range(attribute, range, opts = {})
        message, low_message, high_message = get_options!([opts],
                                                          :message,
                                                          :low_message,
                                                          :high_message)
        matcher = ensure_inclusion_of(attribute).
          in_range(range).
          with_message(message).
          with_low_message(low_message).
          with_high_message(high_message)
        should matcher.description do
          assert_accepts matcher, subject
        end
      end

      # Ensure that the attribute is numeric
      #
      # Options:
      # * <tt>:message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
      #   Regexp or string.  Default = <tt>I18n.translate('activemodel.errors.messages.not_a_number')</tt>
      #
      # Example:
      #   should_validate_numericality_of :age
      #
      def should_validate_numericality_of(*attributes)
        message = get_options!(attributes, :message)
        attributes.each do |attribute|
          matcher = validate_numericality_of(attribute).
            with_message(message)
          should matcher.description do
            assert_accepts matcher, subject
          end
        end
      end

      # Ensure that the given class methods are defined on the model.
      #
      #   should_have_class_methods :find, :destroy
      #
      def should_have_class_methods(*methods)
        get_options!(methods)
        klass = described_type
        methods.each do |method|
          should "respond to class method ##{method}" do
            assert_respond_to klass, method, "#{klass.name} does not have class method #{method}"
          end
        end
      end

      # Ensure that the given instance methods are defined on the model.
      #
      #   should_have_instance_methods :email, :name, :name=
      #
      def should_have_instance_methods(*methods)
        get_options!(methods)
        klass = described_type
        methods.each do |method|
          should "respond to instance method ##{method}" do
            assert_respond_to klass.new, method, "#{klass.name} does not have instance method #{method}"
          end
        end
      end

      # Ensures that the model cannot be saved if one of the attributes listed is not accepted.
      #
      # Options:
      # * <tt>:message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
      #   Regexp or string.  Default = <tt>I18n.translate('activemodel.errors.messages.accepted')</tt>
      #
      # Example:
      #   should_validate_acceptance_of :eula
      #
      def should_validate_acceptance_of(*attributes)
        message = get_options!(attributes, :message)

        attributes.each do |attribute|
          matcher = validate_acceptance_of(attribute).with_message(message)
          should matcher.description do
            assert_accepts matcher, subject
          end
        end
      end
    end
  end
end
