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
      # @rmaise [Saphyr::Error] if no schema was found.
      def find_schema(name)
        @validators.each do |validator|
          schema = validator.find_schema name
          return schema unless schema.nil?
        end
        schema = Saphyr.global_schema name
        raise Saphyr::Error.new "Cannot find schema name: #{name}" if schema.nil?
        schema
      end

      # Get data needed for validation
      # @return The full data or a fragment of data is it exists.
      def data_to_validate()
        return @data if @fragment.nil?
        @fragment
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

      def array_validation()
        fields = @ctx.schema.fields
        unless fields.size == 1
          raise Saphyr::Error.new 'When root is :array, only :_root_ field must exists'
        end

        field = fields['_root_']
        if field.nil?
          raise Saphyr::Error.new 'When root is :array, must define :_root_ field'
        end

        errors = field.validate @ctx, '', @ctx.data_to_validate
        unless errors.size == 0
          @ctx.errors << {
            path: '//',
            errors: errors,
          }
        end
      end

      def object_validation()
        # Computte all conditional fields
        allowed_cond_fields = []
        forbidden_cond_fields = []
        @ctx.schema.conditionals.each do |data|
          condition, schema = data
          if @ctx.validators.last.send condition
            allowed_cond_fields += schema.fields.keys
          else
            forbidden_cond_fields += schema.fields.keys
          end
        end

        do_validation @ctx.schema, allowed_cond_fields, forbidden_cond_fields, []

        fields = @ctx.schema.fields.keys
        @ctx.schema.conditionals.each do |data|
          condition, schema = data

          if @ctx.validators.last.send condition
            do_validation schema, allowed_cond_fields, forbidden_cond_fields, fields
          end
        end
      end

      def do_validation(schema, allowed_cond_fields, forbidden_cond_fields, exclude_fields)
        data = @ctx.data_to_validate

        # Apply casting
        schema.casts.each_pair do |field, method|
          data[field] = @ctx.validators.last.send method, data[field]
        end

        fields = schema.fields
        field_keys = fields.keys
        data_keys = data.keys

        field_names = field_keys.union data_keys
        field_names.each do |name|
          field_path = @ctx.get_path name
          field = fields[name]

          if field.nil?
            next unless @ctx.schema.strict?
            next if allowed_cond_fields.include? name
            next if exclude_fields.include? name

            # If there is already an error for this field we skip adding a new one
            # Bacause if there are many conditional schema, each one will add
            # the field errors.
            k = @ctx.errors.select { |err| err[:path] == field_path }
            next if k.size != 0

            if forbidden_cond_fields.include? name
              @ctx.errors << {
                path: field_path,
                errors: [
                  {
                    type: 'conditional:not-allowed',
                    data: { field: name }
                  },
                ],
              }
            else
              @ctx.errors << {
                path: field_path,
                errors: [
                  {
                    type: 'strict_mode:missing_in_schema',
                    data: { field: name }
                  },
                ],
              }
            end
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
