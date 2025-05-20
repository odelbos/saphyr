module Saphyr
  module Fields

    # The +integer+ field type
    #
    # Allowed options are: +:eq, :gt, :gte, :lt, :lte, :in+.
    class IntegerField < FieldBase
      PREFIX = 'integer'
      EXPECTED_TYPES = Integer
      AUTHORIZED_OPTIONS = [:eq, :gt, :gte, :lt, :lte, :in]

      EXCLUSIVE_OPTIONS = [
        [ :eq, [:_all_] ],
        [ :in, [:_all_] ],
        [ :gt, [:gte] ],
        [ :lt, [:lte] ],
      ]

      # Cannot have: lte == gte, use +:eq+ instead
      NOT_EQUALS_OPTIONS = [
        [:lte, :gte],
      ]

      # Cannot have: gte > lte
      NOT_SUP_OPTIONS = [
        [:gte, :lte],
      ]

      # Cannot have: gt >= lt ... and so on
      NOT_SUP_OR_EQUALS_OPTIONS = [
        [:gt, :lt],
        [:gt, :lte],
        [:gte, :lt],
      ]

      private

        def do_validate(ctx, name, value, errors)
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
