require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  field :code,  :string,  eq: 'CV23'
  field :ref,   :string
  field :name,  :string,  min: 5, max: 15
  field :desc,  :string,  min: 5, required: false
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "code" => "CV23",
  "ref" => "abcd",
  "name" => 'my item',
  "desc" => 'the description',
}

ERROR_DATA = {
  "code" => "CV23",
  "ref" => nil,                        # Error: Not nullable
  "uid" => "a5b7MPTed20f",             # Error: Missing 'uid' in validator
  # "name" => 'my item',               # Error: Missing 'name' in data
  # "desc" => 'bad',                   # No error, 'desc' is not a required field
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
