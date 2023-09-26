# frozen_string_literal: true

RSpec.describe Saphyr::Engine do

  let(:validator) { double('Saphyr::Validator') }
  let(:schema) { double('Saphyr::Schema') }
  let(:data) { {} }
  let(:fragment) { {} }
  let(:path) { '//' }
  let(:errors) { [] }
  subject(:context) { Saphyr::Engine::Context.new([validator], schema, data, fragment, path, errors) }

  describe '#initialize' do
    it 'sets the instance variables correctly' do
      expect(context.validators).to eq [validator]
      expect(context.schema).to eq schema
      expect(context.data).to eq data
      expect(context.fragment).to eq fragment
      expect(context.path).to eq path
      expect(context.errors).to eq errors
    end
  end

  describe '#get_path' do
    context 'when path is the root' do
      it 'returns the correct path' do
        expect(context.get_path('field')).to eq '//field'
      end
    end

    context 'when path is not the root' do
      subject { Saphyr::Engine::Context.new(validator, schema, data, fragment, '//preceding', errors) }
      it 'returns the correct path' do
        expect(subject.get_path('field')).to eq '//preceding.field'
      end
    end
  end

  describe '#find_schema' do
    it 'returns the schema from local validators if found' do
      # validator = double "LocalValidator"
      allow(validator).to receive(:find_schema).with(:schema_name).and_return schema
      context.instance_variable_set :@validators, [validator]
      expect(context.find_schema(:schema_name)).to eq schema
    end

    it 'returns the schema from global schemas if not found locally' do
      allow(validator).to receive(:find_schema).with(:schema_name).and_return nil
      allow(Saphyr).to receive(:global_schema).with(:schema_name).and_return schema
      expect(context.find_schema(:schema_name)).to eq schema
    end

    it 'raises an error if schema not found' do
      allow(validator).to receive(:find_schema).with(:schema_name).and_return nil
      allow(Saphyr).to receive(:global_schema).with(:schema_name).and_return nil
      expect { context.find_schema(:schema_name) }.to raise_error Saphyr::Error, 'Cannot find schema name: schema_name'
    end
  end
end
