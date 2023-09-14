module Saphyr
  # ------------------------------------------------------
  # ASSERT HELPERS
  # ------------------------------------------------------
  module AssertHelpers
    def boolean? value
      value.is_a? TrueClass or value.is_a? FalseClass
    end
  end


  # ------------------------------------------------------
  # ASSERT ERROR CONSTANTS
  # ------------------------------------------------------
  module AssertErrorConstants
    # Base
    ERR_BAD_FORMAT = 'bad-format'
    ERR_TYPE = 'type'
    ERR_IN = 'in'
    ERR_EQ = 'eq'
    # Size
    ERR_SIZE_EQ = 'size-eq'
    ERR_SIZE_LEN = 'size-len'
    ERR_SIZE_MIN = 'size-min'
    ERR_SIZE_MAX = 'size-max'
    # Numeric
    ERR_GT = 'gt'
    ERR_GTE = 'gte'
    ERR_LT = 'lt'
    ERR_LTE = 'lte'
    # String
    ERR_LEN = 'len'
    ERR_MIN = 'min'
    ERR_MAX = 'max'
    ERR_REGEXP = 'regexp'
  end


  # ------------------------------------------------------
  # ASSERT BASE
  # ------------------------------------------------------
  module AssertBaseHelpers
    def assert_class klass, value, errors, error_code=Fields::FieldBase::ERR_TYPE
      unless value.is_a? klass
        errors << {
          type: err(error_code),
          msg: "Expecting type '#{klass.to_s}', got: #{value.class.name}",
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
          msg: "Expecting value to be equals to: #{opt_value}, got: #{value}",
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
          msg: "Expecting value to be in: #{opt_values.to_s}, got: #{value}",
        }
        return false
      end
      true
    end
  end


  # ------------------------------------------------------
  # ASSERT SIZE
  # ------------------------------------------------------
  module AssertSizeHelpers
    def assert_size_eq opt_value, value, errors, error_code=Fields::FieldBase::ERR_SIZE_EQ
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

    def assert_size_len opt_value, value, errors, error_code=Fields::FieldBase::ERR_SIZE_LEN
      assert_size_eq opt_value, value, errors, error_code
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


  # ------------------------------------------------------
  # ASSERT NUMERIC
  # ------------------------------------------------------
  module AssertNumericHelpers
    def assert_numeric_gt opt_value, value, errors, error_code=Fields::FieldBase::ERR_GT
      return nil if opt_value.nil?
      if value <= opt_value
        errors << {
          type: err(error_code),
          msg: "Expecting value > #{opt_value}, got: #{value}",
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
          msg: "Expecting value >= #{opt_value}, got: #{value}",
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
          msg: "Expecting value < #{opt_value}, got: #{value}",
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
          msg: "Expecting value <= #{opt_value}, got: #{value}",
        }
        return false
      end
      true
    end
  end


  # ------------------------------------------------------
  # ASSERT STRING
  # ------------------------------------------------------
  module AssertStringHelpers
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
