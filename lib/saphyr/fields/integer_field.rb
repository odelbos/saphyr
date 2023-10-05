module Saphyr
  module Fields

    # The +integer+ field type
    #
    # Allowed options are: +:eq, :gt, :gte, :lt, :lte, :in+.
    class IntegerField < FieldBase
      PREFIX = 'integer'

      AUTHORIZED_OPTIONS = [:eq, :gt, :gte, :lt, :lte, :in]

      EXCLUSIVE_OPTIONS = [
        [ :eq, [:_all_] ],
        [ :in, [:_all_] ],
        [ :gt, [:gte] ],
        [ :lt, [:lte] ],
      ]

      # Cannot have: lte == gte, use :eq instead
      NOT_EQUALS_OPTIONS = [
        [:lte, :gte],
      ]

      # Cannot have: gte > lte
      NOT_SUP_OPTIONS = [
        [:gte, :lte],
      ]

      def initialize(opts={})
        super

        if opts.key? :lt
          lt = opts[:lt]
          if opts.key? :gt
            if lt >= opts[:gt]
              raise Saphyr::Error.new "Option ':lt' cannot be >= to ':gt'"
            end
          end

          if opts.key? :gte
            if lt >= opts[:gte]
              raise Saphyr::Error.new "Option ':lt' cannot be >= to ':gte'"
            end
          end
        end

        if opts.key? :lte
          lte = opts[:lte]
          if opts.key? :gt
            if lte >= opts[:gt]
              raise Saphyr::Error.new "Option ':lte' cannot be >= to ':gt'"
            end
          end
        end
      end

      private

        def do_validate(ctx, name, value, errors)
          return unless assert_class Integer, value, errors
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
