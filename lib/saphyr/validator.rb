require 'json'

module Saphyr

  # Base class used to define a validator.
  class Validator

    class << self
      attr_accessor :cache_config, :proc_idx

      def config()
        self.cache_config ||= Saphyr::Schema.new
      end

      # ----- Proxy all following method calls to Saphyr::Schema instance
      def strict(value)
        config.strict value
      end

      def root(value)
        config.root value
      end

      def field(name, type, **opts)
        if config.root_array? and name != :_root_
          raise Saphyr::Error.new "Can only define ':_root_' field when root is ':array'"
        end
        if name == :_root_ and type != :array
          raise Saphyr::Error.new "Field ':_root_' must be of type ':array'"
        end
        config.field name, type, **opts
      end

      def schema(name, &block)
        config.schema name, &block
      end

      def conditional(cond, &block)
        #
        # TODO: 'cond' must be a method Symbol or a proc / lambda
        #
        method = cond
        if cond.is_a? Proc
          m = "_proc_#{self.internal_proc_index}".to_sym
          self.send :define_method, m, cond
          method = m
          self.proc_idx += 1
        end
        config.conditional method, &block
      end

      def cast(field, method)
        if method.is_a? Proc
          m = "_proc_#{self.internal_proc_index}".to_sym
          self.send :define_method, m, method
          method = m
          self.proc_idx += 1
        end
        config.cast field, method
      end
      # ----- / Proxy

      private 

        def internal_proc_index()
          self.proc_idx ||= 0
        end
    end

    def initialize()
      @proc_idx = 0
      @ctx = nil
    end

    # Get the validator configuration (ie: the attached schema)
    # @return [Saphyr::Schema]
    def get_config()
      self.class.config
    end

    # Find a local schema
    # @param name [Symbol] The schema name.
    # @return [Saphyr::Schema]
    def find_schema(name)
      self.class.config.find_schema name
    end

    # Get the parsed JSON data.
    # @return [Hash]
    def data()
      return nil if @ctx.nil?
      @ctx.data
    end

    # -----

    # Validate an already parsed JSON document.
    # @param [Hash | Array] The data to validate.
    # @return [Boolean] Wheter the validation was successful or failed.
    def validate(data)
      @ctx = Saphyr::Engine::Context.new [self], get_config, data, nil, '//'
      engine = Saphyr::Engine.new @ctx
      engine.validate
      @ctx.errors.size == 0
    end

    # Parse and validate a JSON document.
    # @param json [String] The JSON document.
    # @return [Boolean] Wheter the validation was successful or failed.
    def parse_and_validate(json)
      validate JSON.parse(json)
    end

    # Get the validation errors
    # @return [Array] An array of errors.
    def errors()
      return [] if @ctx.nil?
      @ctx.errors
    end

    # Get a field from the data to validate.
    # @param [String | Symbol] The field name
    # @return The field value
    def get(field)
      data = @ctx.data_to_validate
      data[field.to_s]
    end
  end
end
