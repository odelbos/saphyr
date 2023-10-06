require_relative '../lib/saphyr'

def errors_to_text errors
  errors.each do |error|
    type = error[:type]
    puts "path: #{error[:path]}"
    errs = error[:errors]
    errs.each do |err|
      puts "  - type: #{err[:type]}"
      puts "  - msg: #{err[:msg]}"
    end
    puts ""
  end
end


#
# Defining the validator
#
class ItemValidator < Saphyr::Validator
  field :id,     :integer,   gte: 1
  field :name,   :string,    min: 7, max: 10
  field :tags,   :array,     len: 4, of_type: :string, opts: {min: 2, max: 10}
  field :boum,   :string,    eq: 'ok'
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id" => 600,
  "name" => 'bob et alo',
  "tags" => ['code', 'ruby', 'json', 'valid'],
  "boum" => 'ok',
}

ERROR_DATA = {
  "id" => 600,
  "name" => 'bob et alo',
  "tags" => ['it-will-fail-too-long', 'top', 'ruby', 1, 'valid', 'ok'],
  "top" => 'tip',
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
  errors_to_text v.errors
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
  errors_to_text v.errors
  puts "Total: #{v.errors.size} errors."
end

puts ''
