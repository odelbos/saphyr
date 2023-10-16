require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  field :id,    :integer,   gte: 1
  field :tags,  :array,     len: 4, of_type: :string, opts: {min: 2, max: 10}
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id" => 600,
  "tags" => ['code', 'ruby', 'json', 'valid'],
}

ERROR_DATA = {
  "id" => 600,
  "tags" => ['it-will-fail-too-long', 'top', 'ruby', 1, 'valid', 'ok'],
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
