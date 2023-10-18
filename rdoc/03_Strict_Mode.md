# How to Use Strict Mode

By default the library is setup as strict mode, this mean that all fields from schema or
data must be described.

```ruby
data = {
  "name" => 'my item',
  "info" => 'Lipsum',                             # Not defined in schema
}

class ItemValidator < Saphyr::Validator
  field :id,    :integer,  gt: 0                  # Not existing in data
  field :name,  :string,   min: 5, max: 50
end
```

when trying to validate the data, we will get 2 errors:

```ruby
v = ItemValidator.new
v.validate data
puts "Validation : FAILED", "\n"
Saphyr::Helpers::Format.errors_to_text validator.errors
```

Output:

```
Validation : FAILED

path: //id
  - type: strict_mode:missing_in_data
  - data: {:field=>"id"}
  - msg: Missing fields in data

path: //info
  - type: strict_mode:missing_in_schema
  - data: {:field=>"info"}
  - msg: Missing fields in schema
```

### Disabling the strict mode

```ruby
class ItemValidator < Saphyr::Validator
  strict false

  field :id,    :integer,  gt: 0
  field :name,  :string,   min: 5, max: 50
end
```

In this case the validation wil succeed.

### Combining the ':required' option with strict mode

```ruby

class ItemValidator < Saphyr::Validator
  field :id,    :integer,  gt: 0
  field :name,  :string,   min: 5, max: 50
  field :info,  :string,   min: 5, max: 50, required: false
end
```

This will ensure that the following data example are both valid:

```ruby
data1 = {
  "id" => 235,
  "name" => 'my item',
}

data2 = {
  "id" => 235,
  "name" => 'my item',
  "info" => 'Lipsum ...',
}
```
