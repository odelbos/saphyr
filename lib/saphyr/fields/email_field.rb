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
          unless value =~ ::URI::MailTo::EMAIL_REGEXP
            errors << {
              type: err('invalid'),
              data: {
                _val: value
              }
            }
          end
        end
    end
  end
end
