module Saphyr
  module Asserts

    module BaseAssert
      def assert_boolean value
        value.is_a? TrueClass or value.is_a? FalseClass
      end

      def assert_class(klass, value, errors, error_code=Fields::FieldBase::ERR_TYPE)
        klass = [klass] unless klass.is_a? Array
        test = false
        klass.each do |k|
          if value.is_a? k; test = true; break; end
        end
        unless test
          errors << {
            type: err(error_code),
            data: {
              type: klass.to_s,
              got: value.class.name,
            }
          }
        end
        test
      end

      def assert_eq(opt_value, value, errors, error_code=Fields::FieldBase::ERR_EQ)
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

      def assert_in(opt_values, value, errors, error_code=Fields::FieldBase::ERR_IN)
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

      def assert_not_empty(value, errors, error_code=Fields::FieldBase::ERR_NOT_EMPTY)
        if value.empty?
          errors << {
            type: err(error_code),
            data: {
              _val: value,
            }
          }
          return false
        end
        true
      end
    end
  end
end
