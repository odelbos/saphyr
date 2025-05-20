module Saphyr
  module Fields

    # The +boolean+ field type
    #
    # Allowed options are: +:eq+.
    class BooleanField < FieldBase
      PREFIX = 'boolean'
      EXPECTED_TYPES = [TrueClass, FalseClass]
      AUTHORIZED_OPTIONS = [:eq]

      private

        def do_validate(ctx, name, value, errors)
          assert_eq @opts[:eq], value, errors
        end
    end
  end
end
