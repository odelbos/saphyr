# frozen_string_literal: true

RSpec.describe Saphyr::Engine do

  let(:validator) { double('Saphyr::Validator') }
  let(:validators) { [ validator ] }
  let(:schema) { double('Saphyr::Schema') }
  let(:data) { {} }
  let(:fragment) { {} }
  let(:path) { '//' }
  let(:errors) { [] }

  let(:ctx) { Saphyr::Engine::Context.new(validators, schema, data, fragment, path, errors) }
  let(:engine) { described_class.new(ctx) }

  describe "#initialize" do
    it 'sets the @ctx instance variable' do
      expect(engine.instance_variable_get(:@ctx)).to eq ctx
    end
  end

  context '#validate' do
    let(:validator) { SaphyrTest::OneFieldNoOptValidator.new }
    let(:valid_data) { { "name" => 'my item' } }
    let(:invalid_data) { { "name" => 3 } }
    let(:missing_in_schema_data) { { "name" => 'my item', 'missing' => 'err' } }
    let(:missing_in_data) { {} }
    let(:nil_data) { { "name" => nil, } }

    context "when strict mode: true" do
      context 'with valid data' do
        let(:ctx) { Saphyr::Engine::Context.new(validators, validator.get_config, valid_data, nil, path, errors) }
        it 'has 0 errors' do
          engine.validate
          expect(ctx.errors.size).to be 0
        end
      end

      context 'with invalid data' do
        let(:ctx) { Saphyr::Engine::Context.new(validators, validator.get_config, invalid_data, nil, path, errors) }
        it 'has 1 errors' do
          engine.validate
          expect(ctx.errors.size).to be 1
          expect(ctx.errors.first[:errors].first[:type]).to eq 'string:type'
          expect(ctx.errors.first[:path]).to eq '//name'
        end
      end

      context 'with miissing in data' do
        context 'when field is required' do
          let(:ctx) { Saphyr::Engine::Context.new(validators, validator.get_config, missing_in_data, nil, path, errors) }
          it 'has 1 errors' do
            engine.validate
            expect(ctx.errors.size).to be 1
            expect(ctx.errors.first[:errors].first[:type]).to eq 'strict_mode:missing_in_data'
            expect(ctx.errors.first[:errors].first[:data][:field]).to eq 'name'
            expect(ctx.errors.first[:path]).to eq '//name'
          end
        end

        context 'when field is not required' do
          let(:validator) { SaphyrTest::OneFieldNotRequiredValidator.new }
          let(:ctx) { Saphyr::Engine::Context.new(validators, validator.get_config, missing_in_data, nil, path, errors) }
          it 'has 0 errors' do
            engine.validate
            expect(ctx.errors.size).to be 0
          end
        end
      end

      context 'with miissing in schema' do
        let(:ctx) { Saphyr::Engine::Context.new(validators, validator.get_config, missing_in_schema_data, nil, path, errors) }
        it 'has 1 errors' do
          engine.validate
          expect(ctx.errors.size).to be 1
          expect(ctx.errors.first[:errors].first[:type]).to eq 'strict_mode:missing_in_schema'
          expect(ctx.errors.first[:errors].first[:data][:field]).to eq 'missing'
          expect(ctx.errors.first[:path]).to eq '//missing'
        end
      end
    end

    context "when strict mode: false" do
      let(:validator) { SaphyrTest::OneFieldStrictOffValidator.new }

      context 'with valid data' do
        let(:ctx) { Saphyr::Engine::Context.new(validators, validator.get_config, valid_data, nil, path, errors) }
        it 'has 0 errors' do
          engine.validate
          expect(ctx.errors.size).to be 0
        end
      end

      context 'with invalid data' do
        let(:ctx) { Saphyr::Engine::Context.new(validators, validator.get_config, invalid_data, nil, path, errors) }
        it 'has 1 errors' do
          engine.validate
          expect(ctx.errors.size).to be 1
          expect(ctx.errors.first[:errors].first[:type]).to eq 'string:type'
          expect(ctx.errors.first[:path]).to eq '//name'
        end
      end

      context 'with miissing in data' do
        let(:ctx) { Saphyr::Engine::Context.new(validators, validator.get_config, missing_in_data, nil, path, errors) }
        it 'has 0 errors' do
          engine.validate
          expect(ctx.errors.size).to be 0
        end
      end

      context 'with miissing in schema' do
        let(:ctx) { Saphyr::Engine::Context.new(validators, validator.get_config, missing_in_schema_data, nil, path, errors) }
        it 'has 0 errors' do
          expect(ctx.errors.size).to be 0
        end
      end
    end

    context "when is not nullable" do
      let(:validator) { SaphyrTest::OneFieldNoOptValidator.new }

      context 'with nil data' do
        let(:ctx) { Saphyr::Engine::Context.new(validators, validator.get_config, nil_data, nil, path, errors) }
        it 'has 1 errors' do
          engine.validate
          expect(ctx.errors.size).to be 1
          expect(ctx.errors.first[:errors].first[:type]).to eq 'not-nullable'
          expect(ctx.errors.first[:errors].first[:data][:field]).to eq 'name'
          expect(ctx.errors.first[:path]).to eq '//name'
        end
      end
    end

    context "when is nullable" do
      let(:validator) { SaphyrTest::OneFieldNullableValidator.new }

      context 'with nil data' do
        let(:ctx) { Saphyr::Engine::Context.new(validators, validator.get_config, nil_data, nil, path, errors) }
        it 'has 0 errors' do
          engine.validate
          expect(ctx.errors.size).to be 0
        end
      end
    end

    context "when :default is provided" do
      let(:validator) { SaphyrTest::OneFieldWithDefaultValidator.new }
      let(:valid_1_data) { { 'name' => 'my item', 'active' => true } }
      let(:valid_2_data) { { 'name' => 'my item', 'active' => false } }
      let(:invalid_data) { { 'name' => 'my item' } }

      context 'with valid data (equal to default)' do
        let(:ctx) { Saphyr::Engine::Context.new(validators, validator.get_config, valid_1_data, nil, path, errors) }
        it 'has 0 errors' do
          engine.validate
          expect(ctx.errors.size).to be 0
          expect(valid_1_data['active']).to be true
        end
      end

      context 'with valid data (not equal to default)' do
        let(:ctx) { Saphyr::Engine::Context.new(validators, validator.get_config, valid_2_data, nil, path, errors) }
        it 'has 0 errors' do
          engine.validate
          expect(ctx.errors.size).to be 0
          expect(valid_2_data['active']).to be false
        end
      end

      context 'with invalid data' do
        let(:ctx) { Saphyr::Engine::Context.new(validators, validator.get_config, invalid_data, nil, path, errors) }
        it 'has 0 errors' do
          engine.validate
          expect(ctx.errors.size).to be 0
          expect(invalid_data['active']).to be true
        end
      end
    end
  end
end
