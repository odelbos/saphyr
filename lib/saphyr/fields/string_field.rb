module Saphyr
  module Fields

    # The +string+ field type
    #
    # Allowed options are: +:eq, :len, :min, :max, :in, :regexp+.
    class StringField < FieldBase
      PREFIX = 'string'

      AUTHORIZED_OPTIONS = [:eq, :len, :min, :max, :in, :regexp]

      EXCLUSIVE_OPTIONS = [
        [ :eq, [:_all_] ],
        [ :len, [:eq, :min, :max, :in] ],
        [ :in, [:_all_] ],
      ]

      # Cannot have: min == max, use :len instead
      NOT_EQUALS_OPTIONS = [
        [:min, :max],
      ]

      # Cannot have: min > max
      NOT_SUP_OPTIONS = [
        [:min, :max],
      ]

      private

        def do_validate(ctx, name, value, errors)
          return unless assert_class String, value, errors
          assert_eq @opts[:eq], value, errors
          assert_size_len @opts[:len], value, errors
          assert_size_min @opts[:min], value, errors
          assert_size_max @opts[:max], value, errors
          assert_in @opts[:in], value, errors
          assert_string_regexp @opts[:regexp], value, errors
        end
    end
  end
end
