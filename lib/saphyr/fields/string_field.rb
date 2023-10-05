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

      def initialize(opts={})
        super

        if opts.key? :min  and opts.key? :max
          if opts[:min] > opts[:max]
            raise Saphyr::Error.new "Option ':min' cannot be > to ':max'"
          end

          if opts[:min] == opts[:max]
            raise Saphyr::Error.new "Option ':min' is equalds to ':max', use :len instead"
          end
        end
      end

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
