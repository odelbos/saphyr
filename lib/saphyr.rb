#efrozen_string_literal: true

require_relative "saphyr/version"

# Saphyr is a libray used to validate JSON data using a schema defined with a DSL.
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
      @field_types = {}
    end

    # ---------------------------------------------------- DSL

    # This method is part of the DSL and used to register global field type
    # and global schemas.
    #
    # @param name [String, Symbol] The field type name
    # @param klass [Class] The class used to handle the field type
    def field_type(name, klass)
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
require_relative './saphyr/helpers'
require_relative './saphyr/fields'
require_relative './saphyr/schema'
require_relative './saphyr/validator'
require_relative './saphyr/engine'


#
# Register default field types.
#
Saphyr.register do
  field_type :string, Saphyr::Fields::StringField
  field_type :integer, Saphyr::Fields::IntegerField
  field_type :float, Saphyr::Fields::FloatField
end
