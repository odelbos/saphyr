require 'uri'

module Saphyr
  module Fields

    # The +URL+ field type
    #
    # No options are allowed.
    class UrlField < FieldBase
      PREFIX = 'url'
      EXPECTED_TYPES = String

      private

        def do_validate(ctx, name, value, errors)
          begin
            uri = URI.parse value
            unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
              add_error value, errors
            end
          rescue URI::InvalidURIError
            add_error value, errors
          end
        end

        def add_error(value, errors)
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
