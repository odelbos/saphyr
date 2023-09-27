module Saphyr
  module Asserts

    module ErrorConstants
      # Base
      ERR_NOT_NULLABLE = 'not-nullable'
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
  end
end
