module Saphyr
  module Fields

    class SchemaField < FieldBase
      PREFIX = 'schema'

      AUTHORIZED_OPTIONS = [:name]

      REQUIRED_OPTIONS = [:name]

      private

        def do_validate(ctx, name, value, errors)
          # Find the schema
          schema_name = @opts[:name]
          schema = ctx.find_schema schema_name    # Raise exceeption if not found

          # Create derived engine to handle schema and data fragment.
          field_path = ctx.get_path name
          new_ctx = ctx.derive schema, value, field_path
          engine = Saphyr::Engine.new new_ctx
          engine.validate
        end
    end
  end
end
