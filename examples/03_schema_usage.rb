require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  schema :file do
    field :id,   :integer, gt: 0
    field :name, :string, min: 3
    field :mime, :string, max: 15
  end

  field :id, :integer, gte: 1
  field :image, :schema, name: :file
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id" => 600,
  "image" => {
    "id" => 145,
    "name" => "image.gif",
    "mime" => "image/gif",
  },
}

ERROR_DATA = {
  "id" => 600,
  "type" => 100,
  "image" => {
    "id" => 145,
    "name" => "ab",
    "mime" => "image/gif",
  },
  "description" => nil,
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
