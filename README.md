[![Testing](https://github.com/odelbos/saphyr/actions/workflows/test.yml/badge.svg)](https://github.com/odelbos/saphyr/actions/workflows/test.yml)
[![Gem Version](https://badge.fury.io/rb/saphyr.svg?t=0.5.0)](https://badge.fury.io/rb/saphyr)
![License](https://img.shields.io/badge/license-MIT-blueviolet.svg)

# Saphyr

The purpose of `Saphyr` gem is to provide a simple DSL to easily and quickly
design a validation schema for JSON document (or `Hash`/`Array` structure).

**Features :**

- Provide a DSL to define validation schemas
- Provide some standard field types
- Define you own custom field type
- Conditional field validation
- Field Casting

**Standard field types :**

- Integer, Float, String, Boolean
- Email
- URI
- URL
- Base64
- ipv4 / ipv6
- Country (ISO-3166-1 alpha 2/3)
- Language (ISO-639-1, ISO-639-2)
- DateTime

## Generate documentation

Generate the documentation in `./doc` folder:

    $ yard

Start a http server and serve the documentation:

    $ yard server

## Run tests

```
rspec
```

## Installation

Add it to your Gemfile:

    $ bundle add saphyr
    $ bundle install

Install the gem (globally):

    $ gem install saphyr

# Example of Usage

Some short examples to give a picture of `Saphyr`:

## The most simple usage

```ruby
data = {                      # --- Rules ---
  "id" => 236,                # Integer > 0
  "type" => 1,                # Integer, possible values are : 1, 2 or 3
  "price" => 32.10,           # Float > 0
  "name" => "my item"         # String with: 5 >= size <= 15
  "active" => true            # Boolean
}

class ItemValidator < Saphyr::Validator
  field :id,      :integer,  gt: 0
  field :type,    :integer,  in: [1, 2, 3]          # Field name can be a
  field "price",  :float,    gt: 0                  # Symbol or a String
  field "name",   :string,   min: 5, max: 15
  field :active,  :boolean
end
```

```ruby
v = ItemValidator.new

if v.validate data
  puts "Validation : SUCCESS", "\n"
else
  puts "Validation : FAILED", "\n"
  Saphyr::Helpers::Format.errors_to_text v.errors
end

# Or use: v.parse_and_validate json
```

## A more advanced usage

```ruby
data = {                                 # --- Rules ---
  "id" => 236,                           # Integer > 0
  "name" => "my item",                   # String with: 5 >= size <= 15
  "uploads" => [                         # This array can only have 2 or 3 elements
    {
      "id" => 34,                        # Interger > 0
      "name" => "orig.gif",              # String, with: 7 <= size <= 15
      "mime" => "image/gif",             # String, possible values: ['image/jpeg', 'image/png', 'image/gif']
      "size" => 753745,                  # Integer > 0
      "timestamps" => {
        "created_at" => 1665241021,      # Integer > 0 (unix timestamp)
        "modified_at" => 1665241021      # Integer > 0 (unix timestamp)
      }
    },
    {
      "id" => 376,
      "name" => "medium.jpg",
      "mime" => "image/png",
      "size" => 8946653,
      "timestamps" => {
        "created_at" => 1669215446,
        "modified_at" => 1670943462
      }
    }
  ],
  "timestamps" => {
    "created_at" => 1669215446,
    "modified_at" => 1670943462
  },
  "active" => true,
}

class ItemValidator < Saphyr::Validator
  schema :timestamp do
    field :created_at,   :integer,  gt: 0
    field :modified_at,  :integer,  gt: 0
  end

  schema :upload do
    field :id,          :integer,  gt: 0
    field :name,        :string,   min: 7, max: 15
    field :mime,        :string,   in: ['image/jpeg', 'image/png', 'image/gif']
    field :size,        :integer,  gt: 0
    field :timestamps,  :schema,   name: :timestamp
  end

  field :id,          :integer,  gt: 0
  field :name,        :string,   min: 7, max: 15
  field :uploads,     :array,    min: 2, max: 3, of_schema: :upload
  field :timestamps,  :schema,   name: :timestamp
  field :active,      :boolean,  eq: true
end
```

## Default field value

```ruby
data = {                      # --- Rules ---
  "id" => 236                 # Integer > 0
                              # field 'active' is missing
}

class ItemValidator < Saphyr::Validator
  field :id,      :integer,  gt: 0
  field :active,  :boolean,  default: true
end
```

```ruby
v = ItemValidator.new
v.validate data           # Will success
```

After the validation, the `active` field is added to `data` with his default value:

```ruby
data = {
  "id" => 236,
  "active" => true
}
```

## When root is an array

By default validator root are set to `:object`, but this can be customized.

In this case, only one virtual field must be defined : `:_root_` and it must be of type `:array`

Example with `:of_type` :

```ruby
data = ['fr', 'en', 'es']

class ItemValidator < Saphyr::Validator
  root :array

  field :_root_,  :array,  min: 2,  max: 5,  of_type: :string,  opts: {len: 2}
end
```

Example with `:of_schema` :

```ruby
data = [
  { "id" => 12, "label" => "tag1" },
  { "id" => 15, "label" => "tag2" },
]

class ItemValidator < Saphyr::Validator
  root :array

  schema :tag do
    field :id,     :integer,  gt: 0
    field :label,  :string,   min: 2,  max: 30
  end

  field :_root_,  :array,  min: 2,  max: 4,  of_schema: :tag
end
```

## Conditional fields

Sometime, we can have different fields depending on a specitic field value.

```ruby
data_1 = {
  "id" => 145,
  "type" => "file",

  "name" => "Lipsum ...",    # Condtionals fields:
  "mime" => "image/png",     #   must be defined only if type == 'file'
}

data_2 = {
  "id" => 145,
  "type" => "post",

  "content" => "Lipsum ...",  # Condtionals fields:
  "author" => "Lipsum ...",   #   must be defined only if type == 'post'
}
```

Example of `Validator` with conditional fields:

```ruby
class ItemValidator < Saphyr::Validator
  field :id,    :integer,  gt: 0
  field :type,  :string,   in: ['post', 'file']

  # Using a method call
  conditional :is_file? do           # Will call 'is_file?' method to check the conddtion
    field :name,  :string,  min: 2
    field :mime,  :string,  in: ['image/png', 'image/jpg']
  end

  # Using a lambda
  conditional -> { get(:type) == 'post' } do
    field :content,  :string
    field :author,   :string
  end

  private

    def is_file?                     # Must return: true | false
      get(:type) == 'file'
    end
end
```

## Field casting

```ruby
data = {
  "id"          => 1,
  "name"        => "Lipsum ...",
  "created_at"  => "2023-10-26 10:57:05.29685 +0200",   # Cast to unix timestamp
  "active"      => "Yes",                               # Cast to Boolean
}
```

Casting is applied before validation.

```ruby
class ItemValidator < Saphyr::Validator

  # Using a method call
  cast :created_at, :cast_created_at

  # Using a lambda
  cast :active, -> (value) {
      return true if ['yes', 'y'].include? value.downcase
      return false if ['no', 'n'].include? value.downcase
      value      # Unknown value, returning it back
  }

  # -----

  field :id,          :integer,  gt: 0
  field :name,        :string,   min: 5
  field :created_at,  :integer,  gt: 0
  field :active,      :boolean

  private

    def cast_created_at(value)
      begin
        return DateTime.parse(value).to_time.to_i
      end
      value
    end
end
```

## Global schemas:

```ruby
Saphyr.register do
  schema :timestamp do
    field :created_at,   :integer,  gt: 0
    field :modified_at,  :integer,  gt: 0
  end
end

class ItemValidator < Saphyr::Validator
  # ....
  field :timestamps, :schema, name: :timestamp
end

class PostValidator < Saphyr::Validator
  # ....
  field "timestamps", :schema, name: :timestamp
end
```

# Documentation and HowTo

- [How to define a schema](rdoc/01_Define_Schema.md)
- [An overview of the library field types](rdoc/02_Field_Types.md)
- [How to use strict mode](rdoc/03_Strict_Mode.md)
- [How to define a custom type](rdoc/04_Define_Custom_Field_Type.md)

# Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

# Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/odelbos/saphyr](https://github.com/odelbos/saphyr).

# License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

# Roadmap

- [X] Add field class
- [X] Add internal basic fields (integer, float, string, boolean, array)
- [X] Add validator class
- [X] Add local and global schema
- [X] Add validation engine
- [X] Add conditional field
- [X] Add field casting
- [X] Add default value to field
- [X] Add more internal fields (b64, b62, uuid, ipv4, ipv6, ...)

# Author

@odelbos
