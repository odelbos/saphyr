module Saphyr

  # This class is used to encapsulate schema definition.
  #
  class Schema
    attr_reader :strict, :root, :fields, :schemas

    def initialize()
      @strict, @root = true, :object        # Default values
      @fields, @schemas = {}, {}
    end

    # ---------------------------------------------------- DSL
    def strict(value)
      @strict = value              # TODO: Validate bollean
    end

    def root(value)
      @root = value                # TODO : Validate symbol -> :object or :array
    end

    def field(name, type, **opts)
      # TODO : What if field 'name' already exists?
      name_s = name.to_s                  # Convert Symbol to string
      # Raise exceptions if field type is not found
      @fields[name_s] = Saphyr.config.instanciate_field_type type, opts
    end

    def schema(name, &block)
      schema = Saphyr::Schema.new
      schema.instance_eval &block
      # TODO : What if schema 'name' already exists?
      @schemas[name] = schema
    end
    # -------------------------------------------------- / DSL

    # Find local schema definition
    def find_schema(name)
      @schemas[name]
    end

    def strict?
      @strict
    end

    def root_array?
      @root == :array
    end

    def root_object?
      @root == :object
    end
  end
end