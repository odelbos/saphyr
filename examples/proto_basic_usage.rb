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
  field :code,  :string,  eq: 'CV23'
  field :uid,   :string,  regexp: /^[a-f0-9]+$/
  field :name,  :string,  min: 5, max: 15
  field :desc,  :string,  min: 5, required: false
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "code" => "CV23",
  "uid" => "a5b7ed20f",
  "name" => 'my item',
  "desc" => 'the description',
}

ERROR_DATA = {
  "code" => "err",                     # Error: not equals to 'CV23'
  "uid" => "a5b7MPTed20f",             # Error: MPT don't match regexp
  "name" => 'my item name too long',   # Error: too long >= 15
  "desc" => 'bad',                     # Error: too short <= 5
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
