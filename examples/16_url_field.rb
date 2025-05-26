require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  field :id,       :integer,  gt: 0
  field :isbn,     :url
  field :location, :url
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id"       => 65,
  "isbn"     => 'http://www.test.com/',
  "location" => 'http://test.com/page.html',
}

ERROR_DATA = {
  "id"       => 65,
  "isbn"     => 'urn:isbn:0451450523',  # Error: Bad URL
  "location" => 'not a url',            # Error: Bad URL
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
