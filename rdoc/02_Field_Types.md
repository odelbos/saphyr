# An Overview of Library Field Types

By default the `Saphyr` library is including many field types.

## Common options

All field type have the common `:required`, `:nullable` and `:default` options.

## String

Authorized options for the `:string` type: `[:eq, :len, :min, :max, :in, :regexp]`

Here is an example with all possible options for `:string` type:

```ruby
class MyValidator < Saphyr::Validator
  field :name,      :string
  field :version,   :string,  eq: 'v1.1'               # Field name can be a
  field "fname",    :string,  min: 5, max: 50          # Symbol or a String
  field "lname",    :string,  max: 50
  field "info",     :string,  len: 15
  field :hexa,      :string,  len: 15, regexp: /^[a-f0-9]+$/
  field :nid,       :string,  regexp: /^[A-Z0-9]{15}$/
  field :extension, :string,  in: ['jpg', 'png', 'gif']
  field :location,  :string,  required: false, min: 10, default: 'here'
  field :info,      :string,  nullable: true, max: 1024
end
```

- If you use `:eq` option then you cannot use any of the other options
- If you use `:len` option then you cannot use `:min` and `:max` options
- If you use `:in` option then you cannot use any of the other options

## Integer

Authorized options for the `:integer` type: `[:eq, :gt, :gte, :lt, :lte, :in]`

Here is an example with all possible options for `:integer` type:

```ruby
class MyValidator < Saphyr::Validator
  field :id,       :integer,  gt: 0
  field :nb,       :integer
  field :version,  :integer,  eq: '101'
  field :value,    :integer,  lt: 50
  field :range,    :integer,  gte: 5, lte: 50
  field :velocity, :integer,  in: [10, 20, 30, 40]
  field :count,    :integer,  required: false, gte: 10, default: 20
  field :round,    :integer,  nullable: true, lte: 1024
end
```

- If you use `:eq` option then you cannot use any of the other options
- If you use `:in` option then you cannot use any of the other options

## Float

Authorized options for the `:float` type: `[:eq, :gt, :gte, :lt, :lte, :in]`

Here is an example with all possible options for `:float` type:

```ruby
class MyValidator < Saphyr::Validator
  field :value,     :float
  field :velocity,  :float,  eq: 15.1
  field :x_axis,    :float,  gt: 0.0
  field :y_axis,    :float,  lt: 50
  field :z_axis,    :float,  gte: 5, lte: 50
  field :focale,    :float,  in: [3.14, 1.618, 6.35]
  field :price,     :float,  required: false, gte: 10, default: 22.2
  field :discount,  :float,  nullable: true, lte: 1024
end
```

- If you use `:eq` option then you cannot use any of the other options
- If you use `:in` option then you cannot use any of the other options

## Boolean

Authorized options for the `:boolean` type: `[:eq]`

Here is an example with all possible options for `:boolean` type:

```ruby
class MyValidator < Saphyr::Validator
  field :payed,   :boolean
  field :valid,   :boolean,  eq: true
  field :option,  :boolean,  eq: false
  field :active,     :boolean,  required: false, default: true
  field :processed,  :boolean,  nullable: true
end
```

## URI and URL

No options allowed for the `:uri` and `:url` types.

```ruby
class MyValidator < Saphyr::Validator
  field :email,    :uri       # valid@email.com
  field :isbn,     :uri       # urn:isbn:0451450523
  field :location, :uri       # https://example.com/page.html

  field :site,     :url       # http://www.test.com/
  field :blog,     :url       # http://test.com/page.html
end
```

## Base64

Authorized options for the `:b64` type: `[:strict]`

Here is an example with all possible options for `:b64` type:

```ruby
class MyValidator < Saphyr::Validator
  field :content,  :b64                    # By default :strict == true
  field :text,     :b64,  strict: false
end
```

In strict mode `:strict == true`:

- Line breaks are not allowed
- Padding must be correct (length % 4 == 0)

Not in strict mode `:strict == false`:

- Line breaks are allowed
- Padding is not required

## IP

Authorized options for the `:ip` type: `[:kind]`

Here is an example with all possible options for `:ip` type:

```ruby
class MyValidator < Saphyr::Validator
  field :web1,   :ip                 # Can be ipv4 or ipv6
  field :db,     :ip,  kind: :ipv4   # Must be an ipv4
  field :cache,  :ip,  kind: :ipv6   # Must be an ipv6
end
```

## Array

Authorized options for the `:array` type: `[:len, :min, :max, :of_type, :of_schema, :opts]`

The `:array` type is little bit different than the other types.

The following options `[:len, :min, :max]` are for the array size then you must define
the type of the array element, this is where `:of_type` and `:of_schema` options
take place.

- One of this option is required: `:of_type` and `:of_schema`
- If you use `:len` option then you cannot use `:min`, `:max` options

### Example with `of_type`:

```ruby
data = {
  'tags' => ['code', 'ruby', 'json']
}

class MyValidator < Saphyr::Validator
  field :tags,  :array,  of_type: :string, opts: {max: 50}
end

class MyValidator < Saphyr::Validator
  field :tags,  :array,  min: 1, max: 10, of_type: :string, opts: {max: 50}
  #                      |-------------|                    |-------------|
  #                             |                                  |
  # Size of array must be: 1 >= s <= 10                            |
  #                                                                |
  #               This 'opts' are for the elements of the array, ie: 'string' type
end
```

### Example with `of_schema`:

- When using `:of_schema` then `:opts` cannot be used

```ruby
data = {
  'code' => 'AGF30',
  'tags' => [
    {'id' => 234, 'label' => 'ruby'},
    {'id' => 567, 'label' => 'elixir'}
  ]
}

class MyValidator < Saphyr::Validator
  schema :tag do
    field :id,     :integer,  gt: 0
    field :label,  :string,   min: 2, max: 30
  end

  field :code,  :string,  min: 5,  max: 10
  field :tags,  :array,   of_schema: :tag
end
```

## Schema

The schema field type does not have any option.

It is used to describe the structure hierarchy of the document. The referenced schema
can local to the validator or global to `Saphyr` library.

To find the schema, we first search it in the validator, if there isn't the named schema in
the validtor then you search it in the global `Saphyr` registry.  
_(and if not found an exception is raised)_

Using a local validator schema:

```ruby
data = {
  # ....
  "timestamps": {
    "created_at": 1669215446,           # Unix timestamp
    "modified_at": 1670943462
  }
}

class ItemValidator < Saphyr::Validator
  schema :timestamp do
    field :created_at,   :integer,  gt: 0
    field :modified_at,  :integer,  gt: 0
  end

  # ....
  field :timestamps,  :schema,  name: :timestamp
end
```

Using a global schema:

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
