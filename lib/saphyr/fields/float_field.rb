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
          unless value.is_a? Float
            errors << {
              type: err('type'),
              msg: "Expecting type 'Float', got: #{value.class.name}",
              data: {
                expect: 'Float',
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

          gt = @opts[:gt]
          unless gt.nil?
            if value <= gt
              errors << {
                type: err('gt'),
                msg: "Expecting value > #{gt}, got: #{value}",
                data: {
                  expect: gt,
                  got: value,
                }
              }
            end
          end

          gte = @opts[:gte]
          unless gte.nil?
            if value < gte
              errors << {
                type: err('gte'),
                msg: "Expecting value >= #{gte}, got: #{value}",
                data: {
                  expect: gte,
                  got: value,
                }
              }
            end
          end

          lt = @opts[:lt]
          unless lt.nil?
            if value >= lt
              errors << {
                type: err('lt'),
                msg: "Expecting value > #{lt}, got: #{value}",
                data: {
                  expect: lt,
                  got: value,
                }
              }
            end
          end

          lte = @opts[:lte]
          unless lte.nil?
            if value > lte
              errors << {
                type: err('lte'),
                msg: "Expecting value >= #{lte}, got: #{value}",
                data: {
                  expect: lte,
                  got: value,
                }
              }
            end
          end

          in_values = @opts[:in]
          unless in_values.nil?
            unless in_values.include? value
              errors << {
                type: err('in'),
                msg: "Expecting value to be in: #{in_values.to_s}, got: #{value}",
                data: {
                  expect: in_values,
                  got: value,
                }
              }
            end
          end
        end
    end
  end
end
