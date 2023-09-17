# frozen_string_literal: true

RSpec.describe Saphyr do

  describe 'Module expectation' do
    it 'must have a version number' do
      expect(Saphyr::VERSION).not_to be nil
    end

    it 'respond to .config' do
      is_expected.to respond_to :config
    end

    it 'must have a config' do
      expect(Saphyr.config).to be_an_instance_of(Saphyr::Config)
    end

    it 'respond to .register' do
      is_expected.to respond_to :register
    end

    it 'must have a :string field type' do
      field_types = Saphyr.config.field_types
      expect(field_types[:string].name).to eq('Saphyr::Fields::StringField')
    end

    it 'must have a :integer field type' do
      field_types = Saphyr.config.field_types
      expect(field_types[:integer].name).to eq('Saphyr::Fields::IntegerField')
    end

    it 'must have a :float field type' do
      field_types = Saphyr.config.field_types
      expect(field_types[:float].name).to eq('Saphyr::Fields::FloatField')
    end
  end

  describe 'Module DSL' do
    describe '.register' do
      it 'registers a new field type' do
        class CustomField < Saphyr::Fields::FieldBase
        end

        Saphyr.register do
          field_type :custom_field, CustomField
        end

        field_types = Saphyr.config.field_types
        expect(field_types[:custom_field].name).to eq('CustomField')
      end

      it 'registers a new schema' do
        Saphyr.register do
          schema :custom do
            field :name, :string
          end
        end

        schemas = Saphyr.config.schemas
        expect(schemas[:custom]).to be_a(Saphyr::Schema)
      end
    end 
  end

  describe '.global_schema' do
    it 'returns a specific global schema' do
      Saphyr.register do
        schema :custom do
          field :field1, :string
        end
      end

      schema = Saphyr.global_schema :custom
      expect(schema).to be_an_instance_of(Saphyr::Schema)
    end
  end
end
