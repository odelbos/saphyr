require 'uri'

module Saphyr
  module Fields

    # The +URI+ field type
    #
    # No options are allowed.
    class UriField < FieldBase
      PREFIX = 'uri'
      EXPECTED_TYPES = String

      private

        def do_validate(ctx, name, value, errors)
          begin
            URI.parse value
          rescue URI::InvalidURIError
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
