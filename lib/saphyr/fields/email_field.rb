require 'uri'

module Saphyr
  module Fields

    # The +email+ field type
    #
    # No options are allowed.
    class EmailField < FieldBase
      PREFIX = 'email'
      EXPECTED_TYPES = String

      private

        def do_validate(ctx, name, value, errors)
          return unless assert_not_empty value, errors
          assert_string_regexp ::URI::MailTo::EMAIL_REGEXP, value, errors
        end
    end
  end
end
