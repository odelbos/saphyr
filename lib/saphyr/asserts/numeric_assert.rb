module Saphyr
  module Asserts

    module NumericAssert
      def assert_numeric_gt opt_value, value, errors, error_code=Fields::FieldBase::ERR_GT
        return nil if opt_value.nil?
        if value <= opt_value
          errors << {
            type: err(error_code),
            data: {
              _val: value,
              gt: opt_value,
            }
          }
          return false
        end
        true
      end

      def assert_numeric_gte opt_value, value, errors, error_code=Fields::FieldBase::ERR_GTE
        return nil if opt_value.nil?
        if value < opt_value
          errors << {
            type: err(error_code),
            data: {
              _val: value,
              gte: opt_value,
            }
          }
          return false
        end
        true
      end

      def assert_numeric_lt opt_value, value, errors, error_code=Fields::FieldBase::ERR_LT
        return nil if opt_value.nil?
        if value >= opt_value
          errors << {
            type: err(error_code),
            data: {
              _val: value,
              lt: opt_value,
            }
          }
          return false
        end
        true
      end

      def assert_numeric_lte opt_value, value, errors, error_code=Fields::FieldBase::ERR_LTE
        return nil if opt_value.nil?
        if value > opt_value
          errors << {
            type: err(error_code),
            data: {
              _val: value,
              lte: opt_value,
            }
          }
          return false
        end
        true
      end
    end
  end
end
