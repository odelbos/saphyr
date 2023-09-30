module Saphyr
  module Asserts

    module SizeAssert
      def assert_size_len opt_value, value, errors, error_code=Fields::FieldBase::ERR_SIZE_LEN
        # assert_size_eq opt_value, value, errors, error_code
        return nil if opt_value.nil?
        unless value.size == opt_value
          errors << {
            type: err(error_code),
            msg: "Expecting size equals to: #{opt_value}, got: #{value.size}",
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
            msg: "Expecting size >= #{opt_value}, got: #{value.size}",
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
            msg: "Expecting size <= #{opt_value}, got: #{value.size}",
          }
          return false
        end
        true
      end
    end
  end
end
