# Saphyr

The purpose of `Saphyr` gem is to provide a simple DSL to easily and quickly
design a validation schema for JSON document.  

_**Note :**_

There are already a bunch of gem doing this job, like: `json-schema`, `json_schema`,
`json_schemer` all based on the [JSON Standard](https://json-schema.org/understanding-json-schema/index.html) to define a validation schema.
It's a really nice crafted standard but his usage is not really intuitive.

Actually the `Saphyr` gem volontary does not support the `json-schema` standard to describe
the validation schema and focus on simplicity with an easy to use DSL.

## Installation

Add it to your Gemfile:

    $ bundle add saphyr

Install the gem:

    $ gem install saphyr


## Generate documentation

Generate the documentation in `./doc` folder:

    $ yard

Start a http server and serve the documentation:

    $ yard serve

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
  field :type,    :integer,  in: [1, 2, 3]
  field :price,   :float,    gt: 0
  field :name,    :string,   min: 5, max: 15
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
data = {                               # --- Rules ---
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

## When root is an array

By default validator root are set to +:object+, but this can be customized.

In this case, only one virtual field must be defined : `:_root_` and it must be of type `:array`

Example with +:of_type+ :

```ruby
data = ['fr', 'en', 'es']

class ItemValidator < Saphyr::Validator
  root :array

  field :_root_,  :array,  min: 2,  max: 5,  of_type: :string,  opts: {len: 2}
end
```

Example with +:of_schema+ :

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

# Documentation and HowTo

- [How to define a schema](rdoc/01_Define_Schema.md)
- [An overview of the library field types](rdoc/02_Field_Types.md)
- [How to use strict mode](rdoc/03_Strict_Mode.md)

# Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

# Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/odelbos/saphyr](https://github.com/odelbos/saphyr).

# License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
