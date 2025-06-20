require 'date'

module Saphyr
  module Fields

    # The +DateTime+ field type.
    #
    # Allowed options is: +:format+
    class DateTimeField < FieldBase
      PREFIX = 'datetime'
      EXPECTED_TYPES = String
      AUTHORIZED_OPTIONS = [:format]

      private

        def do_validate(ctx, name, value, errors)
          return unless assert_not_empty value, errors
          begin
            if @opts[:format].nil?
              DateTime.parse value
            else
              DateTime.strptime value, @opts[:format]
            end
          rescue
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
