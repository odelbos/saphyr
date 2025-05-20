require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  field :id,      :integer,  gt: 0
  field :name,    :string,   min: 5, max: 15
  field :active,  :boolean,  default: true
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_1_DATA = {
  "id" => 145,
  "name" => 'my item',
  "active" => false,
}

VALID_2_DATA = {
  "id" => 145,
  "name" => 'my item',
}


# ----------------------------------------------
# Validate data
# ----------------------------------------------
v = ItemValidator.new
validate v, VALID_1_DATA

puts 'Data after validation'
puts '--------------------------------------------'
p VALID_1_DATA

# -----

puts "\n--------------------------------------------"
puts ' With valid data (without `active` field)'
puts '--------------------------------------------'

validate v, VALID_2_DATA, false

puts 'Data after validation'
puts '--------------------------------------------'
p VALID_2_DATA
