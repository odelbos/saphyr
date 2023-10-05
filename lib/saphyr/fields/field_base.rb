module Saphyr
  module Fields

    class FieldBase
      # Prefix use to format error code
      # @note You must Override this class constants in your field type class
      PREFIX = 'base'

      include Saphyr::Asserts::ErrorConstants
      include Saphyr::Asserts::BaseAssert
      include Saphyr::Asserts::SizeAssert
      include Saphyr::Asserts::NumericAssert
      include Saphyr::Asserts::StringAssert

      # A hash containing the options of the field.
      attr_reader :opts

      # Every field type has the +:required+ and +:nullable+ options.
      # @api private
      DEFAULT_OPT_VALUES = {required: true, nullable: false}.freeze
      # @api private
      DEFAULT_OPTS = DEFAULT_OPT_VALUES.keys.freeze

      # NOTE: 
      # Override following constants to manage options

      # List of authorized options.
      # @note Override this class constant if you want to use this feature.
      AUTHORIZED_OPTIONS = []


      # Definition of exclusive options
      # @note Override this class constant if you want to use this feature.
      EXCLUSIVE_OPTIONS = []


      def initialize(opts={})
        if opts.key? :required
          unless assert_boolean opts[:required]
            raise Saphyr::Error.new "Option ':required' must be a Boolean"
          end
        end
        if opts.key? :nullable
          unless assert_boolean opts[:nullable]
            raise Saphyr::Error.new "Option ':nullable' must be a Boolean"
          end
        end

        unless authorized_options.size == 0
          opts.keys.each do |opt|
            next if  opt == :required or opt == :nullable
            unless authorized_options.include? opt
              raise Saphyr::Error.new "Unauthorized option: #{opt}"
            end
          end
        end

        exclusive_options.each do |data|
          opt, excluded = data
          if opts.include? opt
            if excluded.first == :_all_
              excluded = authorized_options - [opt]
            end
            unless opts.keys.intersection(excluded).size == 0
              raise Saphyr::Error.new "You can't use #{excluded.to_s} options, if you use #{excluded.to_s} options, if you use : :#{opt}"
            end
          end
        end

        @opts = DEFAULT_OPT_VALUES.merge opts
      end

      # -----

      # Get the +PREFIX+ setting.
      # @return [String] The prefix
      def prefix
        self.class::PREFIX
      end

      # -----

      # Get the +AUTHORIZED_OPTIONS+ options
      # @return [Array]
      def authorized_options
        self.class::AUTHORIZED_OPTIONS
      end

      # Get the +EXCLUSIVE_OPTIONS+ options
      # @return [Array]
      def exclusive_options
        self.class::EXCLUSIVE_OPTIONS
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
        # NOTE: Nullable is handle by the engine.
        errors = []
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
