require 'json'

module Saphyr

  # The engine used to handle the validation processus.
  # @api private
  class Engine

    # Class used to encapsule the validation engine context.
    # @api private
    class Context
      attr_reader :validators, :schema, :data, :fragment, :path, :errors

      def initialize(validators, schema, data, fragment, path, errors=[])
        @validators = validators
        @schema = schema
        @data = data
        @fragment = fragment
        @path = path
        @errors = errors
      end

      # Create a new context derived from the current one.
      # @param schema [Saphyr::Schema] The schema associated with the new context.
      # @param fragment [Hash] The data fragment.
      # @param path [String] The path of the new context.
      def derive(schema, fragment, path)
        Context.new @validators, schema, @data, fragment, path, @errors
      end

      # Get the current field path from the root of the document.
      # @return [String]
      def get_path(name)
        return @path + name if @path == '//'
        return @path if name == ''
        @path + '.' + name
      end

      # Find a schema given his name.
      # Lookup first into the local validators if there isn't any schema found then
      # lookup into the global schemas.
      # @param name [Symbol] The name of the schema.
      # @return [Saphyr::Schema]
      # @raise [Saphyr::Error] if no schema was found.
      def find_schema(name)
        @validators.each do |validator|
          schema = validator.find_schema name
          return schema unless schema.nil?
        end
        schema = Saphyr.global_schema name
        raise Saphyr::Error.new "Cannot find schema name: #{name}" if schema.nil?
        schema
      end
    end

    # -----

    def initialize(ctx)
      @ctx = ctx
    end

    def validate
      array_validation if @ctx.schema.root_array?
      object_validation if @ctx.schema.root_object?
    end

    private

      def data_to_validate()
        return @ctx.data if @ctx.fragment.nil?
        @ctx.fragment
      end

      def array_validation()
        # TODO: Implement business logic when root is an array.
        raise Saphyr::Error.new 'Not yet implemented!'
      end

      def object_validation()
        fields = @ctx.schema.fields
        data = data_to_validate

        field_keys = fields.keys
        data_keys = data.keys

        field_names = field_keys.union data_keys
        field_names.each do |name|
          field_path = @ctx.get_path name
          field = fields[name]

          if field.nil?
            next unless @ctx.schema.strict?
            @ctx.errors << {
              path: field_path,
              errors: [
                {
                  type: 'strict_mode:missing_in_schema',
                  data: {
                    field: name,
                  }
                }
              ],
            }
            next
          end

          unless data.key? name
            next unless @ctx.schema.strict?
            if field.required?
              @ctx.errors << {
                path: field_path,
                errors: [
                  {
                    type: 'strict_mode:missing_in_data',
                    data: {
                      field: name,
                    }
                  }
                ],
              }
            end
            next
          end

          value = data[name]

          if value.nil?
            unless field.nullable?
              @ctx.errors << {
                path: field_path,
                errors: [
                  {
                    type: Saphyr::Fields::FieldBase::ERR_NOT_NULLABLE,
                    data: {
                      field: name,
                    }
                  }
                ],
              }
            end
            next
          end

          errors = field.validate @ctx, name, value
          unless errors.size == 0
            @ctx.errors << {
              path: field_path,
              errors: errors,
            }
          end
        end
      end
  end
end
