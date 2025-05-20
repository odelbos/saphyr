module Saphyr
  module Fields

    class ArrayField < FieldBase
      PREFIX = 'array'
      EXPECTED_TYPES = Array
      AUTHORIZED_OPTIONS = [:len, :min, :max, :of_type, :of_schema, :opts]

      REQUIRED_ONE_OF_OPTIONS = [:of_type, :of_schema]

      EXCLUSIVE_OPTIONS = [
        [ :len, [:min, :max] ],
        [ :of_schema, [:opts] ],
      ]

      # Cannot have: min == max, use +:len+ instead
      NOT_EQUALS_OPTIONS = [
        [:min, :max],
      ]

      # Cannot have: min > max
      NOT_SUP_OPTIONS = [
        [:min, :max],
      ]

      def initialize(opts={})
        super

        # TODO : Check that :of_type exists

        # TODO : Check that :of_schema exists
      end

      private 

        def do_validate(ctx, name, value, errors)
          assert_size_len @opts[:len], value, errors
          assert_size_min @opts[:min], value, errors
          assert_size_max @opts[:max], value, errors

          of_type = @opts[:of_type]
          unless of_type.nil?
            opts = {}
            field_type_opts = @opts[:opts]
            opts = field_type_opts unless field_type_opts.nil?

            # Raise exception if field type is not found
            field_type = Saphyr.config.instanciate_field_type of_type, opts
            value.each_with_index do |current, index|
              field_path = make_path ctx, name, index
              errors = field_type.validate ctx, name, current
              if errors.size != 0
                ctx.errors << {
                  path: field_path,
                  errors: errors,
                }
              end
            end
          end

          of_schema = @opts[:of_schema]
          unless of_schema.nil?
            value.each_with_index do |current, index|
              field_path = make_path ctx, name, index
              schema = ctx.find_schema of_schema      # Raise exceptions if not found
              new_ctx = ctx.derive schema, current, field_path
              engine = Saphyr::Engine.new new_ctx
              engine.validate
            end
          end
        end

        def make_path(ctx, name, index)
          return ctx.get_path "[#{index}]" if name == ''
          ctx.get_path "#{name}.[#{index}]"
        end
    end
  end
end
