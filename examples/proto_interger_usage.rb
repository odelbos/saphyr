require_relative '../lib/saphyr'

#
# Defining the validator
#
class ItemValidator < Saphyr::Validator
  field :code,  :integer,  eq: 45
  field :uid,   :integer,  gt: 20, lt: 50
  field :type,  :integer,  in: [3, 5, 7]
  field :ref,  :integer,   gte: 0
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "code" => 45,
  "uid"  => 34,
  "type" => 5,
  "ref"  => 123,
}

ERROR_DATA = {
  "code" => 12,                         # Error: not equals to 45
  "uid"  => 91,                         # Error: > 50
  "type" => 9,                          # Error: Not in [3, 5, 7]
  "ref"  => -12,                        # Error: Not >= 0
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
