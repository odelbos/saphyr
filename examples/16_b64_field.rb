require_relative '../lib/saphyr'
require_relative './common'
require 'base64'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  field :id,       :integer,  gt: 0
  field :content,  :b64                    # By default :strict == true
  field :text,     :b64,  strict: false
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id"       => 65,
  "content"  => 'SGVsbG8=',
  "text"     => "SGVs\nbG8=\n",
}

ERROR_DATA = {
  "id"       => 65,
  "content"  => "SGVs\nbG8=\n",      # Error: Bad base64
  "text"     => 'not-b54**str',      # Error: Bad base64
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
