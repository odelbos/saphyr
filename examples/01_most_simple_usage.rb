require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  field :id,      :integer,  gt: 0
  field :uid,     :string,   regexp: /^[a-f0-9]+$/
  field :code,    :string,   eq: 'CV23'
  field :ref,     :string,   len: 4
  field :name,    :string,   min: 5, max: 15
  field :active,  :boolean,  eq: true
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id" => 145,
  "uid" => "a5b7ed20f",
  "code" => "CV23",
  "ref" => "abcd",
  "name" => 'my item',
  "active" => true,
}

ERROR_DATA = {
  "id" => "abcd",                      # Error: Bad type
  "uid" => "a5b7MPTed20f",             # Error: Don't match regexp
  "code" => "err",                     # Error: Bot equals to 'CV23'
  "ref" => "abcdef",                   # Error: Size not equals to 4
  "name" => 'my item name too long',   # Error: Too long >= 15
  "active" => false,                   # Error: Must be True
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
