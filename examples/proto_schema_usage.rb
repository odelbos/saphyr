require_relative '../lib/saphyr'

#
# Defining the validator
#
class ItemValidator < Saphyr::Validator
  schema :file do
    field :id, :integer, gt: 0
    field :name, :string, min: 3
    field :mime, :string, max: 15
  end

  field :id, :integer, gte: 1
  field :image, :schema, name: :file
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id" => 600,
  "image" => {
    "id" => "PIzKhdjdoQi0QQqVCJsTkb4wXzfubpKB",
    "name" => "image.gif",
    "mime" => "image/gif",
  },
}

ERROR_DATA = {
  "id" => 600,
  "type" => 100,
  "image" => {
    "id" => "PIzKhdjdoQi0QQqVCJsTkb4wXzfubpKB",
    "name" => "ab",
    "mime" => "image/gif",
  },
  "description" => nil,
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
