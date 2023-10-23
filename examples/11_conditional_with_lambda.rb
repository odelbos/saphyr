require_relative '../lib/saphyr'
require_relative './common'

# ----------------------------------------------
# Defining validation schema
# ----------------------------------------------
class ItemValidator < Saphyr::Validator
  field :id,    :integer,   gt: 0
  field :type,  :string,    in: ['post', 'file']
  field :code,  :string

  conditional -> { get(:type) == 'file' } do
    field :name,  :string,  min: 2
    field :mime,  :string,  in: ['image/png', 'image/jpg']
  end

  conditional -> { get(:type) == 'post' } do
    field :content,   :string
    field :author,    :string
  end

  conditional -> { get(:code) == 'R3' } do
    field :ref,  :string,  min: 2
  end
end


# ----------------------------------------------
# Defining some data to validate
# ----------------------------------------------
VALID_DATA_1 = {
  "id" => 145,
  "type" => "file",
  "code" => "R3",

  # Condtionals fields: if type == file
  "name" => "Lipsum ...",
  "mime" => "image/png",

  # Condtionals fields: if code == R3
  "ref" => "Lipsum ...",
}


VALID_DATA_2 = {
  "id" => 145,
  "type" => "post",
  "code" => "OP",

  # Condtionals fields: if type == psot
  "content" => "Lipsum ...",
  "author" => "Lipsum ...",
}


VALID_DATA_3 = {
  "id" => 145,
  "type" => "post",
  "code" => "R3",

  # Condtionals fields: if type == psot
  "content" => "Lipsum ...",
  "author" => "Lipsum ...",

  # Condtionals fields: if code == R3
  "ref" => "Lipsum ...",
}


ERROR_DATA = {
  "id" => 145,
  "type" => "post",
  "code" => "R3",

  # Condtionals fields: if type == file
  "name" => "Lipsum ...",
  "mime" => "image/png",

  # Condtionals fields: if code == R3
  "ref" => "Lipsum ...",
}


# ----------------------------------------------
# Validate data
# ----------------------------------------------
v = ItemValidator.new

# Example using: v.validate(data)
#
validate v, VALID_DATA_1

validate v, VALID_DATA_2

validate v, VALID_DATA_3

validate v, ERROR_DATA
