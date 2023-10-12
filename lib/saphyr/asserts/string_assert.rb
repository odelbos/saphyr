module Saphyr
  module Asserts

    module StringAssert
      def assert_string_regexp opt_value, value, errors, error_code=Fields::FieldBase::ERR_REGEXP
        return nil if opt_value.nil?
        unless value =~ opt_value
          errors << {
            type: err(error_code),
            data: {
              _val: value,
              regexp: opt_value,
            }
          }
          return false
        end
        true
      end
    end
  end
end
