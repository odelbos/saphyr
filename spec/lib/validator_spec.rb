# frozen_string_literal: true

RSpec.describe Saphyr::Validator do

  describe '.config' do
    it 'returns a Saphyr::Schema object' do
      expect(Saphyr::Validator.config).to be_an_instance_of Saphyr::Schema
    end
  end

  context 'Part of DSL' do
    describe '.strict' do
      it 'sets strict mode in the configuration' do
        Saphyr::Validator.strict true
        expect(Saphyr::Validator.config.instance_variable_get :@strict).to eq true
        # expect(Saphyr::Validator.config.strict?).to eq true
      end
    end

    describe '.root' do
      it 'sets default root to: :object' do
        expect(Saphyr::Validator.config.instance_variable_get :@root).to eq :object
      end

      it 'sets provided root' do
        Saphyr::Validator.root :array
        expect(Saphyr::Validator.config.instance_variable_get :@root).to eq :array
      end
    end

    #
    # TODO: Test with and withtout options
    #
    describe '.field' do
      it 'adds a field to the configuration' do
        Saphyr::Validator.field :name, :string
        expect(Saphyr::Validator.config.fields['name']).to be_an_instance_of Saphyr::Fields::StringField
      end
    end
    #

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

    # TODO:Try to dynamically construct a Validator
    # let(:validator) do
    #   c = described_class.new
    #   c.class.class_eval do
    #     field :name, :string
    #   end
    #   # c.instance_eval <<-METHOD
    #   described_class.class_eval <<-METHOD
    #       def do_validate(ctx, name, value, errors)
    #         return unless assert_class String, value, errors
    #       end
    #   METHOD
    #   described_class.send :private, :do_validate
    #   c
    # end

    let(:validator) { SaphyrTest::OneFieldNoOptValidator.new }
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
  # TODO: #erros don't need to be tested ? (too easay methods)
  #
end
