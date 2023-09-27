module Saphyr
  module Asserts

    module StringAssert
      def assert_string_regexp opt_value, value, errors, error_code=Fields::FieldBase::ERR_REGEXP
        return nil if opt_value.nil?
        unless value =~ opt_value
          errors << {
            type: err(error_code),
            # TODO : Becarefull of the size of the value, we should limit it
            msg: "Value failed to match regexp: #{opt_value.to_s}, got: #{value}",
          }
          return false
        end
        true
      end
    end
  end
end
