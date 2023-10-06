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
  schema :upload do
    field :id,          :integer,  gte: 1
    field :name,        :string,   min: 7, max: 10
    field :mime,        :string,   in: ['image/jpeg', 'image/png', 'image/gif']
    field :size,        :integer,  gte: 1         # Size cannot be 0 byte
  end

  field :id,       :integer,  gte: 1
  field :uploads,  :array,    min: 2, max: 3, of_schema: :upload
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id" => 600,
  "uploads" => [
    {
      "id" => 34,
      "name" => 'orig.gif',
      "mime" => 'image/gif',
      "size" => 753745,
    },
    {
      "id" => 376,
      "name" => 'medium.jpg',
      "mime" => 'image/png',
      "size" => 8946653,
    },
  ],
}

ERROR_DATA = {
  "id" => 600,
  "name" => 'bob et alo',
  "uploads" => [
    {
      "id" => 34,
      "name" => 'original.gif',
      "mime" => 'image/error',
      "size" => '753745',
    },
    {
      "id" => 376,
      "name" => 'medium.jpg et alors quoi',
      "mime" => 'image/jpeg',
      "size" => 8946653,
    },
    {
      "id" => 234,
      "name" => 'short.jpg',
      "mime" => 'image/jpeg',
      "size" => 464565656,
    },
    {
      "id" => 678,
      "name" => 'big.jpg',
      "mime" => 'image/jpeg',
      "size" => 545646,
    },
  ],
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
