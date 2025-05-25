require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  field :id,       :integer,  gt: 0
  field :email,    :uri
  field :isbn,     :uri
  field :location, :uri
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id"       => 65,
  "email"    => 'valid@email.com',
  "isbn"     => 'urn:isbn:0451450523',
  "location" => 'https://example.com/page.html',
}

ERROR_DATA = {
  "id"       => 65,
  "email"    => 'not a email',      # Error: Bad URI
  "isbn"     => 'not a isbn',       # Error: Bad URI
  "location" => 'not a location',   # Error: Bad URI
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
