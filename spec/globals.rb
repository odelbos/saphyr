module SaphyrTest

  # -----------------------------------------------------
  # Validators
  # -----------------------------------------------------
  # Globals validators shared by all tests
  #
  class OneFieldNoOptValidator < Saphyr::Validator
    field :name, :string
  end

  class BasicValidator < Saphyr::Validator
    field :name, :string
    # TODO: Add some different fields with options
  end

  # -----------------------------------------------------
  # Fields
  # -----------------------------------------------------
  # Globals fields shared by all tests
  #
  class FieldTest < Saphyr::Fields::FieldBase
    PREFIX = 'test'
  end
end
