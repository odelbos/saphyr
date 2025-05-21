# How To Define a Field Type

It's possible to define your own custom type.

You can take inspiration from `lib/saphyr/fields/*_field.rb`.

Here is an example:

## Define custom B62 field

```ruby
class B62Field < Saphyr::Fields::FieldBase
  PREFIX = 'b62'
  EXPECTED_TYPES = String
  AUTHORIZED_OPTIONS = [:len, :min, :max]

  EXCLUSIVE_OPTIONS = [
    [ :len, [:min, :max] ],      # It mean if you use 'len' then you
  ]                              # you can't use 'min' or 'max' and vice versa

  private

    def do_validate(ctx, name, value, errors)
      assert_size_len @opts[:len], value, errors
      assert_size_min @opts[:min], value, errors
      assert_size_max @opts[:max], value, errors
      assert_string_regexp /^[a-zA-Z0-9]+$/, value, errors, ERR_BAD_FORMAT
    end
end
```

## Register the custom type

```ruby
Saphyr.register do
  field_type :b62, B62Field
end
```

## Use the custom type in a validator

```ruby
class ItemValidator < Saphyr::Validator
  field :id,     :integer,  gte: 1
  field :uuid,   :b62,      min: 10, max: 100
end
```