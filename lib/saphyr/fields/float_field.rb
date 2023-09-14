module Saphyr
  module Fields

    # The +float+ field type
    #
    # Allowed options are: +:eq, :gt, :gte, :lt, :lte, :in+.
    class FloatField < FieldBase
      PREFIX = 'float'

      AUTHORIZED_OPTIONS = [:eq, :gt, :gte, :lt, :lte, :in]

      private

        def do_validate(ctx, name, value, errors)
          return unless assert_class Float, value, errors
          assert_eq @opts[:eq], value, errors
          assert_numeric_gt @opts[:gt], value, errors
          assert_numeric_gte @opts[:gte], value, errors
          assert_numeric_lt @opts[:lt], value, errors
          assert_numeric_lte @opts[:lte], value, errors
          assert_in @opts[:in], value, errors
        end
    end
  end
end
