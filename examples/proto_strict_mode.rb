require_relative '../lib/saphyr'

#
# Defining the validator
#
class ItemValidator < Saphyr::Validator
  field :code,  :string,  eq: 'CV23'
  field :ref,   :string
  field :name,  :string,  min: 5, max: 15
  field :desc,  :string,  min: 5, required: false
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "code" => "CV23",
  "ref" => "abcd",
  "name" => 'my item',
  "desc" => 'the description',
}

ERROR_DATA = {
  "code" => "CV23",
  "ref" => nil,                        # Error: Not nullable
  "uid" => "a5b7MPTed20f",             # Error: Missing 'uid' in validator
  # "name" => 'my item',               # Error: Missing 'name' in data
  # "desc" => 'bad',                   # No error, 'desc' is not a required field
}


# ----------------------------------------------
# 4) Validate data
# ----------------------------------------------
v = ItemValidator.new

# Example using: v.validate(data)
#
puts "--------------------------------------------"
puts ' With valid data'
puts "--------------------------------------------"
if v.validate VALID_DATA
  puts "\nValidation : SUCCESS", "\n"
else
  puts "\nValidation : FAILED", "\n"
  Saphyr::Helpers::Format.errors_to_text v.errors
end


# Example using: v.parse_and_validate(json)
#
puts "--------------------------------------------"
puts ' With invalid data'
puts "--------------------------------------------"
error_json = ERROR_DATA.to_json          # Convert our data to a JSON string

if v.parse_and_validate error_json
  puts "\nValidation : SUCCESS", "\n"
  data = v.data                          # Get back the parse JSON result
else
  puts "\nValidation : FAILED", "\n"
  # p v.errors
  # puts JSON.pretty_generate(v.errors)
  Saphyr::Helpers::Format.errors_to_text v.errors

  puts "Total: #{v.errors.size} errors."
end

puts ''
