require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  schema :timestamp do
    field :created_at,   :integer,  gt: 0
    field :modified_at,  :integer,  gt: 0
  end

  schema :upload do
    field :id,          :integer,  gt: 0
    field :name,        :string,   min: 7, max: 15
    field :mime,        :string,   in: ['image/jpeg', 'image/png', 'image/gif']
    field :size,        :integer,  gt: 0
    field :timestamps,  :schema,   name: :timestamp
  end

  field :id,          :integer,  gt: 0
  field :name,        :string,   min: 7, max: 15
  field :uploads,     :array,    min: 1, max: 3, of_schema: :upload
  field :timestamps,  :schema,   name: :timestamp
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id" => 236,
  "name" => "my item",
  "uploads" => [
    {
      "id" => 34,
      "name" => "orig.gif",
      "mime" => "image/gif",
      "size" => 753745,
      "timestamps" => {
        "created_at" => 1665241021,
        "modified_at" => 1665241021
      }
    },
  ],
  "timestamps" => {
    "created_at" => 1669215446,
    "modified_at" => 1670943462
  }
}


ERROR_DATA = {
  "id" => 236,
  "name" => "my item name too long",     # Error: Too long > 15
  "uploads" => [                         # Error: Too many array elements
    {
      "id" => 34,
      "name" => "orig.gif",
      "mime" => "image/on-error",        # Error: Not in authorized values
      "size" => 753745,
      "timestamps" => {
        "created_at" => "2023/07/15",    # Error: Not an Integer
        "modified_at" => 1665241021
      }
    },
    {
      "id" => 376,
      "name" => "medium.jpg",
      "mime" => "image/png",
      "size" => 8946653,
      "timestamps" => {
        "created_at" => 1669215446,
        "modified_at" => -15             # Error : Negative integer
      }
    },
    {
      "id" => 521,
      "name" => "medium.jpg",
      "mime" => "image/png",
      "size" => 8946653,
      "timestamps" => {
        "created_at" => 1669215446,
        "modified_at" => 1670943462
      }
    },
    {
      "id" => 123,
      "name" => "medium.jpg",
      "mime" => "image/png",
      "size" => "on-error",               # Error: Not an Integer
      "timestamps" => {
        "created_at" => 1669215446,
        "modified_at" => 1670943462
      }
    }
  ],
  # "timestamps" => {                     # Error: Missing field in data (strict-mode)
  #   "created_at" => 1669215446,
  #   "modified_at" => 1670943462
  # }
  "meta" => "undeclared field"            # Error: Missing field in schema (strict-mode)
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
