require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  field :id,     :integer,  gt: 0
  field :email,  :email
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id"    => 145,
  "email" => 'valid@email.com',
}

ERROR_DATA = {
  "id"    => 145,
  "email" => 'not a email',   # Error: Bad email
}


# ----------------------------------------------
# Validate data
# ----------------------------------------------
v = ItemValidator.new

# Example using: v.validate(data)
validate v, VALID_DATA

# Example using: v.parse_and_validate(json)
error_json = ERROR_DATA.to_json          # Convert data to a JSON string
parse_and_validate v, error_json
