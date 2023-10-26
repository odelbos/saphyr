require_relative '../lib/saphyr'
require 'date'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  # Cast are applied before validation

  # Using a method call
  cast :created_at, :created_at_cast

  # Using a lambda
  cast :active, -> (value) {
      return true if ['yes', 'y'].include? value.downcase
      false
  }

  # -----

  field :id,          :integer,  gt: 0
  field :name,        :string,   min: 5
  field :created_at,  :integer,  gt: 0
  field :active,      :boolean

  private

    def created_at_cast(value)
      begin
        return DateTime.parse(value).to_time.to_i
      end
      value
    end
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id" => 1,
  "name" => "Lipsum ...",
  "active" => "Yes",                                   # Will be casted to Boolean
  "created_at" => "2023-10-26 10:57:05.29685 +0200",   # Will casted to unix timestamp
}


# ----------------------------------------------
# Validate data
# ----------------------------------------------
v = ItemValidator.new

puts '--------------------------------------------'
puts ' With valid data'
puts '--------------------------------------------'

v.validate VALID_DATA

puts "\nValidation : SUCCESS", "\n"

puts '--------------------------------------------'
puts 'Data after casting'
puts '--------------------------------------------'
p VALID_DATA
# p v.data
puts '--------------------------------------------'
