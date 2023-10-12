module Saphyr
  module Asserts

    module BaseAssert
      def assert_boolean value
        value.is_a? TrueClass or value.is_a? FalseClass
      end

      def assert_class klass, value, errors, error_code=Fields::FieldBase::ERR_TYPE
        unless value.is_a? klass
          errors << {
            type: err(error_code),
            msg: "Expecting type '#{klass.to_s}', got: #{value.class.name}",
            data: {
              type: klass.to_s,
              got: value.class.name,
            }
          }
          return false
        end
        true
      end

      def assert_eq opt_value, value, errors, error_code=Fields::FieldBase::ERR_EQ
        return nil if opt_value.nil?
        unless value == opt_value
          errors << {
            type: err(error_code),
            data: {
              _val: value,
              eq: opt_value,
            }
          }
          return false
        end
        true
      end

      def assert_in opt_values, value, errors, error_code=Fields::FieldBase::ERR_IN
        return nil if opt_values.nil?
        unless opt_values.include? value
          errors << {
            type: err(error_code),
            data: {
              _val: value,
              in: opt_values,
            }
          }
          return false
        end
        true
      end
    end
  end
end
