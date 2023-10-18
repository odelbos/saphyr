# How To Define a Schema

A validation schema is basicly a class inheriting
from `Saphyr::Validator` and using the DSL to describe the schema.

```ruby
data = {
  "name" => 'my item',
}

class ItemValidator < Saphyr::Validator
  # Declaring the 'name' field into the validation schema:

  field :name,  :string,   min: 5, max: 50
  #       |        |       |-------------|
  #       |        |               |
  #      name     type           options (depending on the type)

  # The field name can be a Sring or Symbol:
  field 'name',  :string,   min: 5, max: 50
end
```

By default the `Saphyr` library provide many field types, like: `:integer`,
`:float`, `:string`, `:array` ...

_(You can also define your own custom field type, we'll see that later)_

Example of some types:

```ruby
data = {
  "id"     => 721,            # Integer: > 0
  "type"   => 2,              # Integer: possible value 1, 2 or 3
  "price"  => 27.60,          # Float: > 0
  "name"   => 'my item',      # String: 5 >= len <= 50
  "active" => true,           # Boolean
}

class ItemValidator < Saphyr::Validator
  field :id,      :integer,  gt: 0
  field :type,    :integer,  in: [1, 2, 3]
  field :price,   :float,    gt: 0
  field :name,    :string,   min: 5, max: 50
  field :active,  :boolean
end
```

Each `Validator` can embed local schemas used to describe the structure of data:

```ruby
data = {
  "id"    => 721,
  "name"  => 'my item',
  "timestamps" => {
    "created_at"   => 1669215446,           # Unix timestamp
    "modified_at"  => 1670943462,
  }
}

class ItemValidator < Saphyr::Validator
  schema :timestamp do
    field :created_at,   :integer,  gt: 0
    field :modified_at,  :integer,  gt: 0
  end

  field :id,          :integer,  gt: 0
  field :name,        :string,   min: 5, max: 50
  field :timestamps,  :schema,   name: :timestamp
end
```

The `:timestamp` schema is local to the validator and cannot be accessed by other
validators.

If you need to share a schema between many validators then you can declare it globally:

```ruby
Saphyr.register do
  schema :timestamp do
    field :created_at,   :integer,  gt: 0
    field :modified_at,  :integer,  gt: 0
  end
end

class ItemValidator < Saphyr::Validator
  # ....
  field :timestamps,  :schema,  name: :timestamp
end

class PostValidator < Saphyr::Validator
  # ....
  field :timestamps,  :schema,  name: :timestamp
end
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