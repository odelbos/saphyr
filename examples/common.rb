
def validate(validator, data, show_header=true)
  if show_header
    puts '--------------------------------------------'
    puts ' With valid data'
    puts '--------------------------------------------'
  end
  if validator.validate data
    puts "\nValidation : SUCCESS", "\n"
  else
    puts "\nValidation : FAILED", "\n"
    Saphyr::Helpers::Format.errors_to_text validator.errors
  end
end

def parse_and_validate(validator, json)
  puts '--------------------------------------------'
  puts ' With invalid data'
  puts '--------------------------------------------'
  error_json = ERROR_DATA.to_json          # Convert our data to a JSON string

  if validator.parse_and_validate json
    puts "\nValidation : SUCCESS", "\n"
    data = validator.data                          # Get back the parsed JSON result
  else
    puts "\nValidation : FAILED", "\n"
    # p v.errors
    # puts JSON.pretty_generate(v.errors)
    Saphyr::Helpers::Format.errors_to_text validator.errors

    puts "Total: #{validator.errors.size} errors."
  end
end
