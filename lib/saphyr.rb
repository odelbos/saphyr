#efrozen_string_literal: true

require_relative "saphyr/version"

# Saphyr is a libray used to validate JSON data using a schema defined with a DSL.
#
# == Usage example :
#
# Say you have a JSON literal string or already parsed 'data' like that :
#
#     json = '{"id": 3465, "name": "Bob"}'
# 
#     data = {
#       "id" => 3465,
#       "name" => "Bob",
#     }
#
# Define a Validator with a specific schema :
#
#     class ItemValidator < Saphyr::Validator
#       schema do
#         field :id, :integer, gte: 1, lt: 32000
#         field :name, :string, min: 2, max: 50
#       end
#     end
#
# Validate data :
#
#     v = ItemValidator.new
#     if v.validate data
#       puts "Validation : SUCCESS", "\n"
#     else
#       puts "Validation : FAILED", "\n"
#       Saphyr::Helpers::Format.errors_to_text v.errors
#     end
#
# Or :
#
#     v = ItemValidator.new
#     if v.parse_and_validate json
#       puts "Validation : SUCCESS", "\n"
#       data = v.data                      # Get back the parsed json data
#     else
#       puts "Validation : FAILED", "\n"
#       Saphyr::Helpers::Format.errors_to_text v.errors
#     end
#
module Saphyr
  class Error < StandardError; end

  class << self
    # The global configuration.
    # @return [Saphyr::Config]
    attr_accessor :config

    # This method is part of the DSL used to register global field type or schema.
    # @param block [Block] This block must use the followingDSL methods:
    # 'field_type' and 'schema'
    # @api public
    def register(&block)
      self.config ||= Config.new
      self.config.instance_eval &block
    end

    # Get a specific global schema.
    # @param name [Symbol] The name of the schema
    # @return [Saphyr::Schema]
    # @raise [Saphyr::Error] If schema does not exists.
    # @api public
    def global_schema(name)
      self.config.get_schema name
    end
  end


  # This class is used to encapsulate global settings (field types, schema).
  # @api private
  class Config
    attr_reader :field_types, :schemas

    def initialize()
      @schemas = {}
      @field_types = {
        array: Saphyr::Fields::ArrayField,
        schema: Saphyr::Fields::SchemaField,
      }
    end

    # ---------------------------------------------------- DSL

    # This method is part of the DSL and used to register global field type
    # and global schemas.
    #
    # @param name [String, Symbol] The field type name
    # @param klass [Class] The class used to handle the field type
    def field_type(name, klass)
      raise Saphyr::Error.new "Cannot overwrite ':array' field" if name == :array
      raise Saphyr::Error.new "Cannot overwrite ':schema' field" if name == :schema
      @field_types[name] = klass
    end

    # This method is part of the DSL used to configure global settings.
    # Register a new global schema.
    #
    # == Parameters:
    # name::
    #   The name of the schema
    #   can be `Symbol` or `String`.
    # &block::
    #   The block evaluated by the DSL.
    def schema(name, &block)
      schema = Saphyr::Schema.new
      schema.instance_eval &block
      @schemas[name] = schema
    end

    # -------------------------------------------------- / DSL

    # Instanciate a registered field type.
    # @param type [Symbol] The type name use to register the field type
    # @param opts [Hash] A hash of options to pass to the field type instance.
    # @return [Field Type Object] An instance of the field type.
    def instanciate_field_type(type, opts={})
      klass = @field_types[type]
      raise Saphyr::Error.new "Unknown field : #{type}" if klass.nil?
      Object.const_get(klass.name).new opts
    end

    # Get a specific global schema given his name.
    # @param name [Symbol] The schema name
    # @return [Saphyr::Schema]
    # @raise [Saphyr::Error] If schema does not exists.
    def get_schema(name)
      raise Saphyr::Error.new "Unknown schema : #{name}" unless @schemas.key? name
      @schemas[name]
    end
  end
end


#
# Required files
#
require_relative './saphyr/asserts'
require_relative './saphyr/fields'
require_relative './saphyr/schema'
require_relative './saphyr/validator'
require_relative './saphyr/engine'
require_relative './saphyr/helpers'


#
# Register default field types.
#
Saphyr.register do
  field_type :string, Saphyr::Fields::StringField
  field_type :integer, Saphyr::Fields::IntegerField
  field_type :float, Saphyr::Fields::FloatField
  field_type :boolean, Saphyr::Fields::BooleanField
  field_type :email, Saphyr::Fields::EmailField
  field_type :uri, Saphyr::Fields::UriField
  field_type :url, Saphyr::Fields::UrlField
  field_type :b64, Saphyr::Fields::B64Field
  field_type :ip, Saphyr::Fields::IpField
  field_type :iso_country, Saphyr::Fields::IsoCountryField
  field_type :iso_lang, Saphyr::Fields::IsoLangField
  field_type :datetime, Saphyr::Fields::DateTimeField
end
