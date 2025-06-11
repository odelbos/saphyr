require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  field :id,        :integer,  gt: 0
  field :country1,  :iso_country              # Default : ISO-3166-1 alpha-2
  field :country2,  :iso_country, alpha: 2
  field :country3,  :iso_country, alpha: 3

  field :lang1,     :iso_lang                 # Default : ISO-639-1
  field :lang2,     :iso_lang , version: 1
  field :lang3,     :iso_lang , version: 2
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id"        => 65,
  "country1"  => 'FR',
  "country2"  => 'PT',
  "country3"  => 'BRA',
  "lang1"     => 'kg',
  "lang2"     => 'ro',
  "lang3"     => 'aus',
}

ERROR_DATA = {
  "id"        => 65,
  "country1"  => 'not-country',
  "country2"  => 'BEL',          # Valid alpha-3 but must be alpha-2
  "country3"  => 'ST',           # Valid alpha-2 but must be alpha-3
  "lang1"     => 'not-lang',
  "lang2"     => 'ber',          # Valid ISO-639-2 but must be ISO-639-1
  "lang3"     => 'bi',           # Valid ISO-639-1 but must be ISO-639-2
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
