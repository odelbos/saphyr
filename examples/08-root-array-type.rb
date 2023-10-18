require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  root :array

  field :_root_,  :array,  min: 2,  max: 5,  of_type: :string,  opts: {len: 2}
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = ['fr', 'en', 'es']

ERROR_DATA = ['fr', 'en', 'es', 3, 'it', 'pt']


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
