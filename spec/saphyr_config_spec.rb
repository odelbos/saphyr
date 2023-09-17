# frozen_string_literal: true

RSpec.describe Saphyr::Config do

  let(:config) { described_class.new }

  describe 'Module DSL' do
    describe '#field_type' do
      it 'registers a field type' do
        config.field_type :string, String
        expect(config.field_types[:string]).to eq(String)
      end
    end

    describe '#schema' do
      it 'registers a schema' do
        config.schema :user do
          # ...
        end
        expect(config.schemas[:user]).to be_an_instance_of(Saphyr::Schema)
      end
    end
  end

  describe '#instanciate_field_type' do
    context 'without any options' do
      it 'instantiates a registered field type' do
        config.field_type :string, String
        expect(config.field_types[:string]).to eq(String)
        instance = Saphyr.config.instanciate_field_type :string
        expect(instance).to be_an_instance_of(Saphyr::Fields::StringField)
      end
    end

    context 'with options' do
      it 'instantiates a registered field type' do
        config.field_type :string, String
        expect(config.field_types[:string]).to eq(String)
        instance = Saphyr.config.instanciate_field_type :string, {eq: 'ok'}
        expect(instance).to be_an_instance_of(Saphyr::Fields::StringField)
        expect(instance.opts[:eq]).to eq('ok')
      end
    end

    it 'raises an error for an unknown field type' do
      expect { config.instanciate_field_type(:unknown_type) }.to raise_error(Saphyr::Error, 'Unknown field : unknown_type')
    end
  end

  describe '#get_schema' do
    it 'retrieves a registered schema' do
      config.schema(:user) do
        # ...
      end
      schema = config.get_schema :user
      expect(schema).to be_an_instance_of(Saphyr::Schema)
    end

    it 'raises an error for an unknown schema' do
      expect { config.get_schema(:unknown_schema) }.to raise_error(Saphyr::Error)
    end
  end
end
