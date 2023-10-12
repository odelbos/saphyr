module Saphyr
  module Asserts

    module SizeAssert
      def assert_size_len opt_value, value, errors, error_code=Fields::FieldBase::ERR_SIZE_LEN
        return nil if opt_value.nil?
        unless value.size == opt_value
          errors << {
            type: err(error_code),
            data: {
              _val: value,
              len: opt_value,
              got: value.size,
            }
          }
          return false
        end
        true
      end

      def assert_size_min opt_value, value, errors, error_code=Fields::FieldBase::ERR_SIZE_MIN
        return nil if opt_value.nil?
        if value.size < opt_value
          errors << {
            type: err(error_code),
            data: {
              _val: value,
              min: opt_value,
              got: value.size,
            }
          }
          return false
        end
        true
      end

      def assert_size_max opt_value, value, errors, error_code=Fields::FieldBase::ERR_SIZE_MAX
        return nil if opt_value.nil?
        if value.size > opt_value
          errors << {
            type: err(error_code),
            data: {
              _val: value,
              max: opt_value,
              got: value.size,
            }
          }
          return false
        end
        true
      end
    end
  end
end
