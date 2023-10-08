module Saphyr
  module Fields
    require_relative './fields/field_base'

    require_relative './fields/array_field'
    require_relative './fields/schema_field'

    require_relative './fields/string_field'
    require_relative './fields/integer_field'
    require_relative './fields/float_field'
  end
end
