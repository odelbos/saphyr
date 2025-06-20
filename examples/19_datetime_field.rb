require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  field :id,        :integer,  gt: 0
  field :datetime1,  :datetime
  field :datetime2,  :datetime, format: '%d/%m/%Y %H:%M:%S'
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------

# 2025-06-12T14:08:00
# 12/06/2025 14:08
# Thursday, 12 June 2025 14:08:00
# 06/12/25 2:08 PM
# 2025-06-12 14:08:00
# 2025-06-12T14:08:00.000Z
# 12-Jun-2025 14:08
# 2025-06-12T14:08:00+02:00
# Thu, 12 Jun 2025 14:08:00 GMT
# 20250612T140800Z

VALID_DATA = {
  "id"        => 65,
  "datetime1"  => 'Thursday, 12 June 2025 14:08:00',
  "datetime2"  => '21/03/2021 10:45:23',
}

ERROR_DATA = {
  "id"        => 65,
  "datetime1"  => 'not-datetime',
  "datetime2"  => '2025-06-12T14:08:00',   # Valid dt but not the required format
}


# ----------------------------------------------
# Validate data
# ----------------------------------------------
v = ItemValidator.new

# Example using: v.validate(data)
validate v, VALID_DATA

# Example using: v.parse_and_validate(json)
error_json = ERROR_DATA.to_json               # Convert data to a JSON string
_data = parse_and_validate v, error_json
