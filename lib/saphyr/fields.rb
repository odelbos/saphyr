module Saphyr
  module Fields

    class FieldBase
      # Prefix use to format error code
      # @note You must Override this class constants in your field type class
      PREFIX = 'base'

      # A hash containing the options of the field.
      attr_reader :opts

      # Every field type has the +:required+ and +:nullable+ options.
      # @api private
      DEFAULT_OPT_VALUES = {required: true, nullable: false}.freeze
      # @api private
      DEFAULT_OPTS = DEFAULT_OPT_VALUES.keys.freeze

      def initialize(opts)
        if opts.key? :required
          unless boolean? opts[:required]
            raise Saphyr::Error.new "Option ':required' must be a Boolean"
          end
        end
        if opts.key? :nullable
          unless boolean? opts[:nullable]
            raise Saphyr::Error.new "Option ':nullable' must be a Boolean"
          end
        end
        @opts = DEFAULT_OPT_VALUES.merge opts
      end

      # -----

      def boolean?(value)
        value.is_a? TrueClass or value.is_a? FalseClass
      end

      # -----

      # Get the +PREFIX+ setting.
      # @return [String] The prefix
      def prefix
        self.class::PREFIX
      end

      # -----

      # Format the error code with the field prefix.
      # @param code [String] The error code.
      # @return [String] The formatted error code.
      def err(code)
        prefix + ':' + code
      end

      # Is the field required?
      def required?
        @opts[:required]
      end

      # Is the field nullable?
      def nullable?
        @opts[:nullable]
      end

      # -----

      # Check if the field value is valid.
      # @param ctx [Saphyr::Engine::Context] The engine context.
      # @param name [String] The field name.
      # @param value [String] The field value.
      def validate(ctx, name, value)
        errors = []
        if value.is_a? NilClass
          return  errors if nullable?
          errors << {
            type: ERR_NOT_NULLABLE,
            msg: 'Not nullable',
          }
          return errors
        end
        do_validate ctx, name, value, errors
        errors
      end

      private

        def do_validate(ctx, name, value, errors)
          raise Saphyr::Error.new 'Not implemented!'
        end
    end
  end
end

require_relative './fields/string_field'