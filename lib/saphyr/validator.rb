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
    # @param data [Hash | Array] The data to validate.
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
    #
    # Use variadic arguments to access deep fields.
    #
    # Examples:
    #
    #     data = {
    #       "id" => 3465,
    #       "info" => {
    #         "suffix" => ["gif", "jpg", "png"]
    #         "size" => 34056
    #       }
    #     }
    #
    #     get("id")                    # => 3435
    #     get("info", "suffix", 1)     # => "jpg"
    #     get("info", "size")          # => 34056
    #     get("name")                  # => raise an exception
    #
    # @return The field value
    # @raise [Saphyr::Error] If field does not exists.
    def get(*args)
      status, value = get_safe(*args)
      raise Saphyr::Error.new 'Requested field does not exists' if status == :err
      value
    end

    # Get a field from the data to validate.
    # (Same as +get()+ but never raise an exception).
    #
    # Use variadic arguments to access deep fields.
    #
    # Examples:
    #
    #     data = {
    #       "id" => 3465,
    #       "info" => {
    #         "suffix" => ["gif", "jpg", "png"]
    #         "size" => 34056
    #       }
    #     }
    #
    #     get("id")                    # => [:ok, 3435]
    #     get("info", "suffix", 1)     # => [:ok, "jpg"]
    #     get("info", "size")          # => [:ok, 34056]
    #     get("name")                  # => [:err, :not_exists]
    #     get("info", "suffix", 5)     # => [:err, :not_index]
    #     get("info", 3)               # => [:err, :not_array]
    #
    # @return An array where first element is the status and second element is the result.
    def get_safe(*args)
      do_get_safe @data, args.reverse
    end

    private

    def do_get_safe(data, args)
      return [:ok, data] if args.size == 0
      key = args.pop
      if data.is_a? Hash
        key = key.to_s if key.is_a? Symbol
        if data.key? key
          return do_get_safe data[key], args
        else
          return [:err, :not_exists]
        end
      elsif data.is_a? Array
        if key.is_a? Integer
          return do_get_safe data[key], args
        else
          return [:err, :not_index]
        end
      else
        return [:err, :not_array]
      end
    end
  end
end
