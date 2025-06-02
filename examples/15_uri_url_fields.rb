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
  field :site,     :url
  field :blog,     :url
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id"       => 65,
  "email"    => 'valid@email.com',
  "isbn"     => 'urn:isbn:0451450523',
  "location" => 'https://example.com/page.html',
  "site"     => 'http://www.test.com/',
  "blog"     => 'http://test.com/page.html',
}

ERROR_DATA = {
  "id"       => 65,
  "email"    => 'not a email',          # Error: Bad URI
  "isbn"     => 'not a isbn',           # Error: Bad URI
  "location" => 'not a location',       # Error: Bad URI
  "site"     => 'urn:isbn:0451450523',  # Error: Bad URL
  "blog"     => 'not a url',            # Error: Bad URL
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
