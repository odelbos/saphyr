require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Define custom B62 field
# ----------------------------------------------
class B62Field < Saphyr::Fields::FieldBase
  PREFIX = 'b62'
  EXPECTED_TYPES = String
  AUTHORIZED_OPTIONS = [:len, :min, :max]

  EXCLUSIVE_OPTIONS = [
    [ :len, [:min, :max] ],
  ]

  private

    def do_validate(ctx, name, value, errors)
      assert_size_len @opts[:len], value, errors
      assert_size_min @opts[:min], value, errors
      assert_size_max @opts[:max], value, errors
      assert_string_regexp /^[a-zA-Z0-9]+$/, value, errors, ERR_BAD_FORMAT
    end
end


# ----------------------------------------------
# Register the custom type
# ----------------------------------------------
Saphyr.register do
  field_type :b62, B62Field
end


# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  field :id,     :integer,  gte: 1
  field :uuid,   :b62,      min: 10, max: 100
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id" => 600,
  "uuid" => "ZHuApzuCOZeWu3549qCsHEYyNwm4Zv",
}

ERROR_DATA = {
  "id" => 600,
  "uuid" => "ZHuApzuCOZe====Wu3549qCwm4Zv",
}


# ----------------------------------------------
# Validate data
# ----------------------------------------------
v = ItemValidator.new

# Example using: v.validate(data)
#
validate v, VALID_DATA

# Example using: v.parse_and_validate(json)
#
error_json = ERROR_DATA.to_json          # Convert data to a JSON string

parse_and_validate v, error_json
