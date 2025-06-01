module Saphyr
  module Fields
    require_relative './fields/field_base'
    require_relative './fields/array_field'
    require_relative './fields/schema_field'

    require_relative './fields/string_field'
    require_relative './fields/integer_field'
    require_relative './fields/float_field'
    require_relative './fields/boolean_field'
    require_relative './fields/email_field'
    require_relative './fields/uri_field'
    require_relative './fields/url_field'
    require_relative './fields/b64_field'
  end
end
