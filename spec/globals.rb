# frozen_string_literal: true

module SaphyrTest

  # -----------------------------------------------------
  # Validators
  # -----------------------------------------------------
  # Globals validators shared by all tests
  #
  class OneFieldNoOptValidator < Saphyr::Validator
    field :name, :string
  end

  class OneFieldStrictOffValidator < Saphyr::Validator
    strict false
    field :name, :string
  end

  class OneFieldNotRequiredValidator < Saphyr::Validator
    field :name, :string, required: false
  end

  class OneFieldNullableValidator < Saphyr::Validator
    field :name, :string, nullable: true
  end

  class BasicValidator < Saphyr::Validator
    field :name, :string
    # TODO: Add some different fields with options
  end

  class ArrayValidator < Saphyr::Validator
    field :type, :array, of_type: :integer
  end

  class SchemaValidator < Saphyr::Validator
    schema :file do
      field :name, :string
    end

    field :upload, :schema, name: :file
  end

  class OneFieldWithDefaultValidator < Saphyr::Validator
    field :name, :string
    field :active, :boolean, default: true
  end

  # -----------------------------------------------------
  # Fields
  # -----------------------------------------------------
  # Globals fields shared by all tests

  class TestFieldBase < Saphyr::Fields::FieldBase
    EXPECTED_TYPES = String
  end

  class FieldTest < Saphyr::Fields::FieldBase
    EXPECTED_TYPES = String
    PREFIX = 'test'
  end
end
