module Saphyr
  module Fields

    # The +string+ field type
    #
    # Allowed options are: +:eq, :len, :min, :max, :regexp+.
    class StringField < FieldBase
      PREFIX = 'string'

      private

        def do_validate(ctx, name, value, errors)
          unless value.is_a? String
            errors << {
              type: err('type'),
              msg: "Expecting type '#{klass.to_s}', got: #{value.class.name}",
              data: {
                expect: 'String',
                got: value.class.name,
              }
            }
            return
          end

          eq = @opts[:eq]
          unless eq.nil?
            if value != eq
            errors << {
              type: err('eq'),
              msg: "Expecting value to be equals to: #{eq}, got: #{value}",
              data: {
                expect: eq,
                got: value,
              }
            }
            end
          end

          len = @opts[:len]
          unless len.nil?
            if value.size != len
            errors << {
              type: err('len'),
              msg: "Expecting size equals to: #{len}, got: #{value.size}",
              data: {
                expect: len,
                got: value.size,
              }
            }
            end
          end

          min = @opts[:min]
          unless min.nil?
            if value.size < min
              errors << {
                type: err('size-min'),
                msg: "Expecting size >= #{min}, got: #{value.size}",
                data: {
                  expect: min,
                  got: value.size,
                }
              }
            end
          end

          max = @opts[:max]
          unless max.nil?
            if value.size > max
              errors << {
                type: err('size-max'),
                msg: "Expecting size <= #{max}, got: #{value.size}",
                data: {
                  expect: max,
                  got: value.size,
                }
              }
            end
          end

          re = @opts[:regexp]
          unless re.nil?
            unless value =~ re
              errors << {
                type: err('regexp'),
                msg: "Failed to match regexp: #{re.to_s}, got: #{value}",
                data: {
                  expect: re.to_s,
                  got: value,
                }
              }
            end
          end
        end
    end
  end
end
