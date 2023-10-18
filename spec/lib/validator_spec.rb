# frozen_string_literal: true

RSpec.describe Saphyr::Validator do

  let(:test_class) { Class.new(Saphyr::Validator) }

  let(:object_validator) {
    test_class.new
  }

  let(:array_validator) {
    v = test_class.new
    v.class.root :array
    v
  }

  describe '.config' do
    it 'returns a Saphyr::Schema object' do
      expect(Saphyr::Validator.config).to be_an_instance_of Saphyr::Schema
    end
  end

  context 'Part of DSL' do
    describe '.strict' do
      it 'sets strict mode in the configuration' do
        expect(object_validator.get_config.instance_variable_get :@strict).to eq true
      end
    end

    describe '.root' do
      it 'sets default root to: :object' do
        expect(object_validator.get_config.instance_variable_get :@root).to eq :object
      end

      it 'sets provided root' do
        expect(array_validator.get_config.instance_variable_get :@root).to eq :array
      end
    end

    #
    # TODO: Test with and withtout options
    #
    describe '.field' do
      context 'when root is :object' do
        Saphyr::Validator.root :object
        it 'adds a field to the configuration' do
          object_validator.class.field :name, :string
          expect(object_validator.get_config.fields['name']).to be_an_instance_of Saphyr::Fields::StringField
        end
      end

      context 'when root is :array' do
        it 'raise an exception if field name is not :_root_' do
          expect { array_validator.class.field(:name, :string) }.to raise_error Saphyr::Error
        end
      end
    end

    describe '.schema' do
      it 'adds a schema to the configuration' do
        Saphyr::Validator.schema :user  do
          field :name, :string
        end
        expect(Saphyr::Validator.config.schemas[:user]).to be_an_instance_of Saphyr::Schema
      end
    end
  end

  describe '#get_config' do
    subject { described_class.new }
    it 'returns a Saphyr::Schema object' do
      expect(subject.get_config).to be_an_instance_of Saphyr::Schema
    end
  end

  describe '#find_schema' do
    subject { described_class.new }
    context 'when schema exists' do
      it 'returns the schema' do
        Saphyr::Validator.schema :user  do
          field :name, :string
        end
        expect(subject.find_schema :user).to be_an_instance_of Saphyr::Schema
      end
    end

    context 'when schema does not exists' do
      it 'returns nil' do
        expect(subject.find_schema :not_exists).to eq nil
      end
    end
  end

  #
  # TODO: #data don't need to be tested ? (too easay methods)
  #

  describe '#validate' do
    let(:validator) {
      v = test_class.new
      v.class.field :name, :string
      v
    }
    let(:valid_data) { { "name" => 'my item', } }
    let(:invalid_data) { { "name" => 3, } }

    context 'with valid data' do
      it 'returns true' do
        expect(validator.validate valid_data).to be true
        expect(validator.errors.size).to be 0
      end
    end

    context 'with invalid data' do
      it 'returns false' do
        expect(validator.validate invalid_data).to be false
        expect(validator.errors.size).to be 1
      end
    end
  end

  #
  # TODO: #parse_and_validate don't need to be tested ? (too easay methods)
  #

  #
  # TODO: #errors don't need to be tested ? (too easay methods)
  #
end
