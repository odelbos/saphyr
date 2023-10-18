module Saphyr
  module Fields

    # The +boolean+ field type
    #
    # Allowed options are: +:eq+.
    class BooleanField < FieldBase
      PREFIX = 'boolean'

      AUTHORIZED_OPTIONS = [:eq]

      private

        def do_validate(ctx, name, value, errors)
          return unless assert_class [TrueClass, FalseClass], value, errors
          assert_eq @opts[:eq], value, errors
        end
    end
  end
end
