require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  schema :upload do
    field :id,    :integer,  gte: 1
    field :name,  :string,   min: 7, max: 10
  end

  field :id,       :integer,  gte: 1
  field :uploads,  :array,    min: 1, max: 3, of_schema: :upload
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id" => 600,
  "uploads" => [
    {
      "id" => 34,
      "name" => 'orig.gif',
    },
  ],
}

ERROR_DATA = {
  "id" => 600,
  "uploads" => [
    {
      "id" => 34,
      "name" => 'original.gif',
    },
    {
      "id" => 376,
      "name" => 'medium.jpg et alors quoi',
    },
    {
      "id" => 234,
      "name" => 'short.jpg',
    },
    {
      "id" => 678,
      "name" => 'big.jpg',
    },
  ],
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
