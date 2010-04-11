require 'shoulda/active_model/matchers/validation_matcher'
require 'shoulda/active_model/matchers/allow_value_matcher'
require 'shoulda/active_model/matchers/ensure_length_of_matcher'
require 'shoulda/active_model/matchers/ensure_inclusion_of_matcher'
require 'shoulda/active_model/matchers/validate_presence_of_matcher'
require 'shoulda/active_model/matchers/validate_format_of_matcher'
require 'shoulda/active_model/matchers/validate_uniqueness_of_matcher'
require 'shoulda/active_model/matchers/validate_acceptance_of_matcher'
require 'shoulda/active_model/matchers/validate_numericality_of_matcher'

module Shoulda # :nodoc:
  module ActiveModel # :nodoc:
    # = Matchers for your ActiveModel models
    #
    # These matchers will test most of the validations and associations for your
    # ActiveModel models.
    #
    #   describe User do
    #     it { should validate_presence_of(:name) }
    #     it { should validate_presence_of(:phone_number) }
    #     %w(abcd 1234).each do |value|
    #       it { should_not allow_value(value).for(:phone_number) }
    #     end
    #     it { should allow_value("(123) 456-7890").for(:phone_number) }
    #   end
    #
    module Matchers
    end
  end
end
