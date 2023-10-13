require_relative '../lib/saphyr'

#
# Defining the validator
#
class ItemValidator < Saphyr::Validator
  field :id,    :float,  gte: 0
  field :code,  :float,  eq: 3.14
  field :uid,   :float,  gt: 5.25, lt: 10.35
  field :type,  :float,  in: [1.6, 3.1, 5.23]
  field :ref,   :float,  lte: 3.0
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id"   => 3.0,
  "code" => 3.14,
  "uid"  => 7.54,
  "type" => 3.1,
  "ref"  => 2.29,
}

ERROR_DATA = {
  "id"   => 'err',              # Error: Not a float
  "code" => 9.48,               # Error: Not 3.14
  "uid"  => 3.0,                # Error: < 5.25
  "type" => 23.56,              # Error: Not in [1.6, 3.1, 5.23]
  "ref"  => 16.3,               # Error: Not < 3.0
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
