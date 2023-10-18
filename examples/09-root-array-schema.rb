require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  root :array

  schema :tag do
    field :id,     :integer,  gt: 0
    field :label,  :string,   min: 2,  max: 30
  end

  field :_root_,  :array,  min: 2,  max: 4,  of_schema: :tag
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = [
  { "id" => 12, "label" => "tag1" },
  { "id" => 15, "label" => "tag2" },
]

ERROR_DATA = [
  { "id" => 12, "label" => "tag1" },
  { "id" => 15, "label" => "t" },
  { "id" => 16, "label" => "tag3" },
  { "id" => "uid", "label" => "tag4" },
]


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
