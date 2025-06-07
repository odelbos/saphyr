require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  field :id,     :integer,  gt: 0
  field :web1,   :ip                 # Can be ipv4 or ipv6
  field :web2,   :ip
  field :db,     :ip,  kind: :ipv4
  field :cache,  :ip,  kind: :ipv6
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA = {
  "id"     => 65,
  "web1"   => '19.123.45.67',
  "web2"   => '2002:cb0a:3cdd:1::1',
  "db"     => '192.168.1.33',
  "cache"  => '2001:db8:85a3::8a2e:370:7334',
}

ERROR_DATA = {
  "id"      => 65,
  "web1"   => 'not-valid-ip',
  "web2"   => 'not-valid-ip',
  "db"     => '2002:cb0a:3cdd:1::1',  # Valid ipv6 but 'db' must be ipv4
  "cache"  => '192.168.1.33',         # Valid ipv4 but 'cache' must be ipv6
}


# ----------------------------------------------
# Validate data
# ----------------------------------------------
v = ItemValidator.new

# Example using: v.validate(data)
validate v, VALID_DATA

# Example using: v.parse_and_validate(json)
error_json = ERROR_DATA.to_json               # Convert data to a JSON string
_data = parse_and_validate v, error_json
